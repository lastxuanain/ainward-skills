#!/usr/bin/env bash
set -euo pipefail

# Sync symlinks from skills/ into local coding agent skill directories (macOS Bash 3.2+ & Linux).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
SKILLS_ROOT="$REPO_ROOT/skills"
LOCAL_CONFIG="$REPO_ROOT/.link.local"
KNOWN_TARGETS="antigravity claude codex opencode cursor"

TARGETS_CSV=""; SKILLS_CSV=""; EXCLUDE_CSV=""
PRUNE="false"; UNLINK="false"; DRY_RUN="false"; STATUS_ONLY="false"; USE_LOCAL="true"
SEEN_CLI_EXCLUDE=0

usage() {
  cat <<'EOF'
Usage: ./scripts/link.sh [options]

  --targets <csv>   Target tools (antigravity,claude,codex,opencode,cursor) or custom paths
  --skills <csv>    Skill names to include (default: all under skills/)
  --exclude <csv>   Skill names to skip (e.g. frontend-craft)
  --prune           Remove excluded repo symlinks (broken repo symlinks are always cleaned)
  --no-prune        Keep excluded repo symlinks
  --unlink          Remove all symlinks pointing into this repo from selected targets
  --status          Show current link state without making changes
  --dry-run, -n     Preview planned actions without modifying the filesystem
  --no-local        Ignore optional .link.local config in repo root
  -h, --help        Show this help message
EOF
}

trim() { local s="${1#"${1%%[![:space:]]*}"}"; printf '%s' "${s%"${s##*[![:space:]]}"}"; }

target_dir_for() {
  case "$1" in
    antigravity) printf '%s/.gemini/config/skills' "$HOME" ;;
    claude)      printf '%s/.claude/skills' "$HOME" ;;
    codex)       printf '%s/.codex/skills' "$HOME" ;;
    opencode)    printf '%s/.config/opencode/skills' "$HOME" ;;
    cursor)      printf '%s/.cursor/skills' "$HOME" ;;
    "~")         printf '%s' "$HOME" ;;
    "~/"*)       printf '%s/%s' "$HOME" "${1#~/}" ;;
    /*)          printf '%s' "$1" ;;
    *)           return 1 ;;
  esac
}

csv_contains() {
  local old_ifs="$IFS" item; IFS=','
  for item in $1; do
    item="$(trim "$item")"
    if [ -n "$item" ] && [ "$item" = "$2" ]; then IFS="$old_ifs"; return 0; fi
  done
  IFS="$old_ifs"; return 1
}

resolve_link_target() {
  local link_path="$1" raw dir parent
  raw="$(readlink "$link_path")" || return 1
  dir="$(dirname "$raw")"
  case "$raw" in
    /*) parent="$(cd -P "$dir" 2>/dev/null && pwd -P)" || { printf '%s' "$raw"; return 0; } ;;
    *)  parent="$(cd -P "$(dirname "$link_path")" 2>/dev/null && cd -P "$dir" 2>/dev/null && pwd -P)" \
          || parent="$(cd "$(dirname "$link_path")" 2>/dev/null && cd "$dir" 2>/dev/null && pwd -P)" \
          || { printf '%s/%s' "$(dirname "$link_path")" "$raw"; return 0; } ;;
  esac
  printf '%s/%s' "$parent" "$(basename "$raw")"
}

is_repo_symlink() {
  [ -L "$1" ] || return 1
  case "$(resolve_link_target "$1")" in "$SKILLS_ROOT"/*) return 0 ;; *) return 1 ;; esac
}

load_local_config() {
  [ -f "$LOCAL_CONFIG" ] || return 0
  local line key val
  while IFS= read -r line || [ -n "$line" ]; do
    line="$(trim "$line")"
    case "$line" in ""|\#*) continue ;; *=*) ;; *) continue ;; esac
    key="$(trim "${line%%=*}")"; val="$(trim "${line#*=}")"
    case "$val" in \"*\") val="${val#\"}"; val="${val%\"}" ;; \'*\') val="${val#\'}"; val="${val%\'}" ;; esac
    case "$key" in
      TARGETS) TARGETS_CSV="$val" ;;
      SKILLS)  SKILLS_CSV="$val" ;;
      EXCLUDE) EXCLUDE_CSV="$val" ;;
      PRUNE)
        case "$val" in
          true|1|yes) PRUNE="true" ;; false|0|no) PRUNE="false" ;;
          *) echo "Error: invalid PRUNE value '$val' in $LOCAL_CONFIG" >&2; exit 1 ;;
        esac ;;
      *) echo "Warning: ignoring unknown key '$key' in $LOCAL_CONFIG" >&2 ;;
    esac
  done < "$LOCAL_CONFIG"
}

for arg in "$@"; do if [ "$arg" = "--no-local" ]; then USE_LOCAL="false"; fi; done
if [ "$USE_LOCAL" = "true" ]; then load_local_config; fi

while [ $# -gt 0 ]; do
  case "$1" in
    --targets)     [ $# -ge 2 ] || { echo "Error: --targets requires a value" >&2; exit 1; }; TARGETS_CSV="$2"; shift 2 ;;
    --targets=*)   TARGETS_CSV="${1#--targets=}"; shift ;;
    --skills)      [ $# -ge 2 ] || { echo "Error: --skills requires a value" >&2; exit 1; }; SKILLS_CSV="$2"; shift 2 ;;
    --skills=*)    SKILLS_CSV="${1#--skills=}"; shift ;;
    --exclude)     [ $# -ge 2 ] || { echo "Error: --exclude requires a value" >&2; exit 1; }
                   if [ "$SEEN_CLI_EXCLUDE" -eq 0 ]; then EXCLUDE_CSV=""; SEEN_CLI_EXCLUDE=1; fi
                   EXCLUDE_CSV="${EXCLUDE_CSV:+$EXCLUDE_CSV,}$2"; shift 2 ;;
    --exclude=*)   if [ "$SEEN_CLI_EXCLUDE" -eq 0 ]; then EXCLUDE_CSV=""; SEEN_CLI_EXCLUDE=1; fi
                   EXCLUDE_CSV="${EXCLUDE_CSV:+$EXCLUDE_CSV,}${1#--exclude=}"; shift ;;
    --prune)       PRUNE="true"; shift ;;
    --no-prune)    PRUNE="false"; shift ;;
    --unlink)      UNLINK="true"; shift ;;
    --status)      STATUS_ONLY="true"; shift ;;
    --dry-run|-n)  DRY_RUN="true"; shift ;;
    --no-local)    shift ;;
    -h|--help)     usage; exit 0 ;;
    *)             echo "Error: unknown option '$1'" >&2; usage >&2; exit 1 ;;
  esac
done

[ -d "$SKILLS_ROOT" ] || { echo "Error: skills directory not found at $SKILLS_ROOT" >&2; exit 1; }

SELECTED_SKILLS=()
if [ -n "$SKILLS_CSV" ]; then
  old_ifs="$IFS"; IFS=','
  for req in $SKILLS_CSV; do
    req="$(trim "$req")"; [ -z "$req" ] && continue
    [ -f "$SKILLS_ROOT/$req/SKILL.md" ] || { IFS="$old_ifs"; echo "Error: skill '$req' not found under $SKILLS_ROOT" >&2; exit 1; }
    csv_contains "$EXCLUDE_CSV" "$req" || SELECTED_SKILLS+=("$req")
  done
  IFS="$old_ifs"
else
  for d in "$SKILLS_ROOT"/*; do
    if [ -d "$d" ] && [ -f "$d/SKILL.md" ]; then
      skill="$(basename "$d")"; csv_contains "$EXCLUDE_CSV" "$skill" || SELECTED_SKILLS+=("$skill")
    fi
  done
fi

TARGETS=()
if [ -n "$TARGETS_CSV" ]; then
  old_ifs="$IFS"; IFS=','
  for t in $TARGETS_CSV; do
    t="$(trim "$t")"; [ -z "$t" ] && continue
    target_dir_for "$t" >/dev/null 2>&1 || { IFS="$old_ifs"; echo "Error: unknown target '$t'" >&2; exit 1; }
    TARGETS+=("$t")
  done
  IFS="$old_ifs"
else
  for t in $KNOWN_TARGETS; do
    tdir="$(target_dir_for "$t")"; if [ -d "$(dirname "$tdir")" ]; then TARGETS+=("$t"); fi
  done
fi
[ ${#TARGETS[@]} -gt 0 ] || { echo "No target coding agent directories detected. Pass --targets <csv>." >&2; exit 1; }

SELECTED_CSV=""
for skill in "${SELECTED_SKILLS[@]+${SELECTED_SKILLS[@]}}"; do SELECTED_CSV="${SELECTED_CSV:+$SELECTED_CSV,}$skill"; done

CNT_LINKED=0; CNT_OK=0; CNT_PRUNED=0; CNT_SKIPPED=0; CNT_MISSING=0
prefix_dry=""; if [ "$DRY_RUN" = "true" ]; then prefix_dry="[dry-run] "; fi

for target in "${TARGETS[@]}"; do
  tdir="$(target_dir_for "$target")"; echo "==> $target ($tdir)"
  if [ "$UNLINK" = "false" ]; then
    if [ "$STATUS_ONLY" = "false" ] && [ ! -d "$tdir" ]; then
      echo "  ${prefix_dry}MKDIR   $tdir"; if [ "$DRY_RUN" = "false" ]; then mkdir -p "$tdir"; fi
    fi
    for skill in "${SELECTED_SKILLS[@]+${SELECTED_SKILLS[@]}}"; do
      src="$SKILLS_ROOT/$skill"; dest="$tdir/$skill"
      if [ -L "$dest" ]; then
        if [ "$(resolve_link_target "$dest")" = "$src" ] && [ -d "$dest" ]; then
          if [ "$STATUS_ONLY" = "true" ]; then echo "  OK      $skill -> $(readlink "$dest")"; else echo "  OK      $skill"; fi
          CNT_OK=$((CNT_OK + 1))
        elif [ "$STATUS_ONLY" = "false" ] && is_repo_symlink "$dest"; then
          echo "  ${prefix_dry}RELINK  $skill -> $src (was $(readlink "$dest"))"
          if [ "$DRY_RUN" = "false" ]; then ln -sfn "$src" "$dest"; fi; CNT_LINKED=$((CNT_LINKED + 1))
        else
          if [ "$STATUS_ONLY" = "true" ]; then echo "  OTHER   $skill -> $(readlink "$dest")"; else echo "  SKIP    $skill (foreign symlink -> $(readlink "$dest"))"; fi
          CNT_SKIPPED=$((CNT_SKIPPED + 1))
        fi
      elif [ -e "$dest" ]; then
        if [ "$STATUS_ONLY" = "true" ]; then echo "  LOCAL   $skill (non-symlink exists)"; else echo "  SKIP    $skill (existing non-symlink at $dest)"; fi
        CNT_SKIPPED=$((CNT_SKIPPED + 1))
      elif [ "$STATUS_ONLY" = "true" ]; then
        echo "  MISSING $skill"; CNT_MISSING=$((CNT_MISSING + 1))
      else
        echo "  ${prefix_dry}LINK    $skill -> $src"
        if [ "$DRY_RUN" = "false" ]; then ln -s "$src" "$dest"; fi; CNT_LINKED=$((CNT_LINKED + 1))
      fi
    done
  fi
  if [ -d "$tdir" ]; then
    for entry in "$tdir"/*; do
      is_repo_symlink "$entry" || continue; ename="$(basename "$entry")"
      if [ "$UNLINK" = "true" ]; then
        echo "  ${prefix_dry}UNLINK  $ename -> $(readlink "$entry")"
        if [ "$DRY_RUN" = "false" ]; then rm "$entry"; fi; CNT_PRUNED=$((CNT_PRUNED + 1))
      elif ! csv_contains "$SELECTED_CSV" "$ename"; then
        if [ "$STATUS_ONLY" = "true" ]; then
          echo "  STALE   $ename -> $(readlink "$entry")"
        elif [ ! -d "$entry" ] || [ "$PRUNE" = "true" ]; then
          echo "  ${prefix_dry}PRUNE   $ename -> $(readlink "$entry")"
          if [ "$DRY_RUN" = "false" ]; then rm "$entry"; fi; CNT_PRUNED=$((CNT_PRUNED + 1))
        fi
      fi
    done
  fi
done

echo ""
if [ "$STATUS_ONLY" = "true" ]; then echo "Summary: ok=$CNT_OK missing=$CNT_MISSING other/local=$CNT_SKIPPED"
else echo "Summary: linked=$CNT_LINKED ok=$CNT_OK pruned=$CNT_PRUNED skipped=$CNT_SKIPPED"; fi
