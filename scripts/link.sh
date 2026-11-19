#!/usr/bin/env bash
set -euo pipefail

# Sync symlinks from this repository's skills/ directory into local coding agent skill directories.
# Compatible with macOS default Bash 3.2+ and Linux Bash.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
SKILLS_ROOT="$REPO_ROOT/skills"
LOCAL_CONFIG="$REPO_ROOT/.link.local"

KNOWN_TARGETS="antigravity claude codex opencode cursor"

TARGETS_CSV=""
SKILLS_CSV=""
EXCLUDE_CSV=""
PRUNE="false"
UNLINK="false"
DRY_RUN="false"
STATUS_ONLY="false"
USE_LOCAL="true"

CLI_TARGETS_SET="false"
CLI_SKILLS_SET="false"
CLI_EXCLUDE_SET="false"
CLI_PRUNE_SET="false"

usage() {
  cat <<'EOF'
Usage: ./scripts/link.sh [options]

Symlink skills from this repository directly into local AI coding agent skill directories.

Options:
  --targets <csv>   Comma-separated target tools or custom paths
                    Known tools: antigravity, claude, codex, opencode, cursor
                    Default: auto-detect installed tools on this machine
  --skills <csv>    Comma-separated skill names to include (default: all under skills/)
  --exclude <csv>   Comma-separated skill names to skip (can be repeated)
  --prune           Remove stale symlinks pointing into this repo (deleted or excluded skills)
  --unlink          Remove all symlinks pointing into this repo from selected targets
  --status          Show current link state across selected targets without making changes
  --dry-run, -n     Preview planned actions without modifying the filesystem
  --no-local        Ignore optional .link.local config in repo root
  -h, --help        Show this help message

Optional local config (.link.local, gitignored):
  TARGETS=antigravity,claude,codex,opencode
  # EXCLUDE=some-skill-name
  PRUNE=true
EOF
}

trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

strip_quotes() {
  local s="$1"
  case "$s" in
    \"*\") s="${s#\"}"; s="${s%\"}" ;;
    \'*\') s="${s#\'}"; s="${s%\'}" ;;
  esac
  printf '%s' "$s"
}

expand_tilde() {
  local p="$1"
  case "$p" in
    "~") printf '%s' "$HOME" ;;
    "~/"*) printf '%s/%s' "$HOME" "${p#~/}" ;;
    *) printf '%s' "$p" ;;
  esac
}

target_base_for() {
  case "$1" in
    antigravity) printf '%s/.gemini/config' "$HOME" ;;
    claude)      printf '%s/.claude' "$HOME" ;;
    codex)       printf '%s/.codex' "$HOME" ;;
    opencode)    printf '%s/.config/opencode' "$HOME" ;;
    cursor)      printf '%s/.cursor' "$HOME" ;;
    /*|~|~/*)    expand_tilde "$1" ;;
    *)           return 1 ;;
  esac
}

target_dir_for() {
  case "$1" in
    antigravity) printf '%s/.gemini/config/skills' "$HOME" ;;
    claude)      printf '%s/.claude/skills' "$HOME" ;;
    codex)       printf '%s/.codex/skills' "$HOME" ;;
    opencode)    printf '%s/.config/opencode/skills' "$HOME" ;;
    cursor)      printf '%s/.cursor/skills' "$HOME" ;;
    /*|~|~/*)    expand_tilde "$1" ;;
    *)           return 1 ;;
  esac
}

csv_contains() {
  local csv="$1"
  local needle="$2"
  local old_ifs="$IFS"
  local item
  IFS=','
  for item in $csv; do
    item="$(trim "$item")"
    if [ -n "$item" ] && [ "$item" = "$needle" ]; then
      IFS="$old_ifs"
      return 0
    fi
  done
  IFS="$old_ifs"
  return 1
}

append_csv() {
  local current="$1"
  local extra="$2"
  if [ -z "$current" ]; then
    printf '%s' "$extra"
  elif [ -z "$extra" ]; then
    printf '%s' "$current"
  else
    printf '%s,%s' "$current" "$extra"
  fi
}

load_local_config() {
  [ -f "$LOCAL_CONFIG" ] || return 0
  local line key val
  while IFS= read -r line || [ -n "$line" ]; do
    line="$(trim "$line")"
    [ -z "$line" ] && continue
    case "$line" in
      \#*) continue ;;
    esac
    case "$line" in
      *=*)
        key="$(trim "${line%%=*}")"
        val="$(strip_quotes "$(trim "${line#*=}")")"
        case "$key" in
          TARGETS)
            [ "$CLI_TARGETS_SET" = "false" ] && TARGETS_CSV="$val"
            ;;
          SKILLS)
            [ "$CLI_SKILLS_SET" = "false" ] && SKILLS_CSV="$val"
            ;;
          EXCLUDE)
            [ "$CLI_EXCLUDE_SET" = "false" ] && EXCLUDE_CSV="$val"
            ;;
          PRUNE)
            if [ "$CLI_PRUNE_SET" = "false" ]; then
              case "$val" in
                true|1|yes) PRUNE="true" ;;
                false|0|no) PRUNE="false" ;;
                *) echo "Error: invalid PRUNE value '$val' in $LOCAL_CONFIG" >&2; exit 1 ;;
              esac
            fi
            ;;
          *)
            echo "Warning: ignoring unknown key '$key' in $LOCAL_CONFIG" >&2
            ;;
        esac
        ;;
    esac
  done < "$LOCAL_CONFIG"
}

# Parse CLI arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --targets)
      [ $# -ge 2 ] || { echo "Error: --targets requires a value" >&2; exit 1; }
      TARGETS_CSV="$2"
      CLI_TARGETS_SET="true"
      shift 2
      ;;
    --targets=*)
      TARGETS_CSV="${1#--targets=}"
      CLI_TARGETS_SET="true"
      shift
      ;;
    --skills)
      [ $# -ge 2 ] || { echo "Error: --skills requires a value" >&2; exit 1; }
      SKILLS_CSV="$2"
      CLI_SKILLS_SET="true"
      shift 2
      ;;
    --skills=*)
      SKILLS_CSV="${1#--skills=}"
      CLI_SKILLS_SET="true"
      shift
      ;;
    --exclude)
      [ $# -ge 2 ] || { echo "Error: --exclude requires a value" >&2; exit 1; }
      EXCLUDE_CSV="$(append_csv "$EXCLUDE_CSV" "$2")"
      CLI_EXCLUDE_SET="true"
      shift 2
      ;;
    --exclude=*)
      EXCLUDE_CSV="$(append_csv "$EXCLUDE_CSV" "${1#--exclude=}")"
      CLI_EXCLUDE_SET="true"
      shift
      ;;
    --prune)
      PRUNE="true"
      CLI_PRUNE_SET="true"
      shift
      ;;
    --no-prune)
      PRUNE="false"
      CLI_PRUNE_SET="true"
      shift
      ;;
    --unlink)
      UNLINK="true"
      shift
      ;;
    --status)
      STATUS_ONLY="true"
      shift
      ;;
    --dry-run|-n)
      DRY_RUN="true"
      shift
      ;;
    --no-local)
      USE_LOCAL="false"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown option '$1'" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ "$USE_LOCAL" = "true" ]; then
  load_local_config
fi

if [ ! -d "$SKILLS_ROOT" ]; then
  echo "Error: skills directory not found at $SKILLS_ROOT" >&2
  exit 1
fi

# Discover available skills in repo
ALL_SKILLS=()
for d in "$SKILLS_ROOT"/*; do
  [ -d "$d" ] || continue
  [ -f "$d/SKILL.md" ] || continue
  ALL_SKILLS+=("$(basename "$d")")
done

if [ ${#ALL_SKILLS[@]} -eq 0 ]; then
  echo "Error: no skills (containing SKILL.md) found under $SKILLS_ROOT" >&2
  exit 1
fi

# Validate explicit --skills if provided
SELECTED_SKILLS=()
if [ -n "$SKILLS_CSV" ]; then
  old_ifs="$IFS"
  IFS=','
  for req in $SKILLS_CSV; do
    req="$(trim "$req")"
    [ -z "$req" ] && continue
    if [ ! -f "$SKILLS_ROOT/$req/SKILL.md" ]; then
      IFS="$old_ifs"
      echo "Error: skill '$req' not found under $SKILLS_ROOT" >&2
      exit 1
    fi
    if ! csv_contains "$EXCLUDE_CSV" "$req"; then
      SELECTED_SKILLS+=("$req")
    fi
  done
  IFS="$old_ifs"
else
  for skill in "${ALL_SKILLS[@]}"; do
    if ! csv_contains "$EXCLUDE_CSV" "$skill"; then
      SELECTED_SKILLS+=("$skill")
    fi
  done
fi

# Resolve target list
TARGETS=()
if [ -n "$TARGETS_CSV" ]; then
  old_ifs="$IFS"
  IFS=','
  for t in $TARGETS_CSV; do
    t="$(trim "$t")"
    [ -z "$t" ] && continue
    if ! target_dir_for "$t" >/dev/null 2>&1; then
      IFS="$old_ifs"
      echo "Error: unknown target '$t' (known: $KNOWN_TARGETS, or pass an absolute/~/ path)" >&2
      exit 1
    fi
    TARGETS+=("$t")
  done
  IFS="$old_ifs"
else
  for t in $KNOWN_TARGETS; do
    base="$(target_base_for "$t")"
    if [ -d "$base" ]; then
      TARGETS+=("$t")
    fi
  done
fi

if [ ${#TARGETS[@]} -eq 0 ]; then
  echo "No target coding agent directories detected. Pass --targets <csv> explicitly." >&2
  exit 1
fi

# Build CSV of selected skills for fast lookup
SELECTED_CSV=""
for skill in "${SELECTED_SKILLS[@]+${SELECTED_SKILLS[@]}}"; do
  SELECTED_CSV="$(append_csv "$SELECTED_CSV" "$skill")"
done

CNT_LINKED=0
CNT_OK=0
CNT_PRUNED=0
CNT_SKIPPED=0
CNT_MISSING=0

is_repo_symlink() {
  local link_path="$1"
  [ -L "$link_path" ] || return 1
  local resolved
  resolved="$(readlink "$link_path")"
  case "$resolved" in
    "$SKILLS_ROOT"/*) return 0 ;;
    *) return 1 ;;
  esac
}

prefix_dry=""
[ "$DRY_RUN" = "true" ] && prefix_dry="[dry-run] "

for target in "${TARGETS[@]}"; do
  tdir="$(target_dir_for "$target")"
  echo "==> $target ($tdir)"

  if [ "$STATUS_ONLY" = "true" ]; then
    for skill in "${SELECTED_SKILLS[@]+${SELECTED_SKILLS[@]}}"; do
      src="$SKILLS_ROOT/$skill"
      dest="$tdir/$skill"
      if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "  OK      $skill -> $src"
        CNT_OK=$((CNT_OK + 1))
      elif [ -L "$dest" ]; then
        echo "  OTHER   $skill -> $(readlink "$dest")"
        CNT_SKIPPED=$((CNT_SKIPPED + 1))
      elif [ -e "$dest" ]; then
        echo "  LOCAL   $skill (non-symlink exists)"
        CNT_SKIPPED=$((CNT_SKIPPED + 1))
      else
        echo "  MISSING $skill"
        CNT_MISSING=$((CNT_MISSING + 1))
      fi
    done
    # Also report any stale repo symlinks in target dir
    if [ -d "$tdir" ]; then
      for entry in "$tdir"/*; do
        [ -L "$entry" ] || continue
        if is_repo_symlink "$entry"; then
          ename="$(basename "$entry")"
          if ! csv_contains "$SELECTED_CSV" "$ename" || [ ! -d "$(readlink "$entry")" ]; then
            echo "  STALE   $ename -> $(readlink "$entry")"
          fi
        fi
      done
    fi
    continue
  fi

  if [ "$UNLINK" = "true" ]; then
    if [ -d "$tdir" ]; then
      for entry in "$tdir"/*; do
        [ -L "$entry" ] || continue
        if is_repo_symlink "$entry"; then
          ename="$(basename "$entry")"
          echo "  ${prefix_dry}UNLINK  $ename -> $(readlink "$entry")"
          if [ "$DRY_RUN" = "false" ]; then
            rm "$entry"
          fi
          CNT_PRUNED=$((CNT_PRUNED + 1))
        fi
      done
    fi
    continue
  fi

  # Ensure target directory exists
  if [ ! -d "$tdir" ]; then
    echo "  ${prefix_dry}MKDIR   $tdir"
    if [ "$DRY_RUN" = "false" ]; then
      mkdir -p "$tdir"
    fi
  fi

  # Link selected skills
  for skill in "${SELECTED_SKILLS[@]+${SELECTED_SKILLS[@]}}"; do
    src="$SKILLS_ROOT/$skill"
    dest="$tdir/$skill"
    if [ -L "$dest" ]; then
      existing="$(readlink "$dest")"
      if [ "$existing" = "$src" ]; then
        echo "  OK      $skill"
        CNT_OK=$((CNT_OK + 1))
      elif is_repo_symlink "$dest"; then
        echo "  ${prefix_dry}RELINK  $skill -> $src (was $existing)"
        if [ "$DRY_RUN" = "false" ]; then
          ln -sfn "$src" "$dest"
        fi
        CNT_LINKED=$((CNT_LINKED + 1))
      else
        echo "  SKIP    $skill (foreign symlink -> $existing)"
        CNT_SKIPPED=$((CNT_SKIPPED + 1))
      fi
    elif [ -e "$dest" ]; then
      echo "  SKIP    $skill (existing non-symlink at $dest)"
      CNT_SKIPPED=$((CNT_SKIPPED + 1))
    else
      echo "  ${prefix_dry}LINK    $skill -> $src"
      if [ "$DRY_RUN" = "false" ]; then
        ln -s "$src" "$dest"
      fi
      CNT_LINKED=$((CNT_LINKED + 1))
    fi
  done

  # Optional prune of stale/excluded symlinks pointing into this repo
  if [ "$PRUNE" = "true" ] && [ -d "$tdir" ]; then
    for entry in "$tdir"/*; do
      [ -L "$entry" ] || continue
      if is_repo_symlink "$entry"; then
        ename="$(basename "$entry")"
        if ! csv_contains "$SELECTED_CSV" "$ename" || [ ! -d "$(readlink "$entry")" ]; then
          echo "  ${prefix_dry}PRUNE   $ename -> $(readlink "$entry")"
          if [ "$DRY_RUN" = "false" ]; then
            rm "$entry"
          fi
          CNT_PRUNED=$((CNT_PRUNED + 1))
        fi
      fi
    done
  fi
done

echo ""
if [ "$STATUS_ONLY" = "true" ]; then
  echo "Summary: ok=$CNT_OK missing=$CNT_MISSING other/local=$CNT_SKIPPED"
else
  echo "Summary: linked=$CNT_LINKED ok=$CNT_OK pruned=$CNT_PRUNED skipped=$CNT_SKIPPED"
fi
