---
name: code-sync
description: >-
  Port scoped changes across branches by intent with parallel isolation. Do NOT
  trigger on plain git merge/pull/push. Triggers: /code-sync, "code sync",
  "sync to branch", "port changes to", "semantic merge", "代码同步", "同步到分支",
  "把改动同步到".
license: MIT
metadata:
  author: ainward
  version: "2.0.0"
---

# Code Sync (语义化代码同步与跨分支移植)

Port bug fixes, features, or refactors onto another branch **by engineering
intent rather than mechanical patch replay**—preserving strict parallel-session
isolation, adapting idiomatically to the target branch's current architecture,
and running straight through whenever no true conflict exists.

## When to use

- Porting changes from **this conversation**, **uncommitted workspace edits**,
  a **diverged branch**, or **specific commits/files** onto a target branch
  (`main`, `develop`, `release/*`), especially when parallel tasks share the
  repo or the target branch has refactored modules/contracts.
- Do **not** use for plain `git merge`, `git pull`, `git push`, or fast-forward
  branch operations where no semantic inspection was requested.

---

## Core rules

1. **Adapt by intent, never replay blindly.** Extract the problem solved and
   behavioral invariants (execution flow, state/contracts, side effects, and
   non-silent error handling), then implement them natively against `<target>`'s
   current module boundaries, shared helpers, types, and tests—never run blind
   `git cherry-pick` or paste obsolete structures onto a refactored target.
2. **Strict bidirectional parallel isolation.**
   - **Source hard allowlist**: When syncing **this conversation's changes
     (`本次对话的改动`)** or named commits/paths, extract **only** files,
     logical hunks, and commits authored in that scope. **Never** run
     `git log <target>..<source>` on a session-scoped sync, and silently ignore
     unrelated dirty files or parallel commits.
   - **Target snapshot only**: Read **only** the current snapshot of `<target>`
     files and direct callers/callees/shared peers relevant to the synced units.
     **Never** browse unrelated `git log` history on `<target>` (except narrow
     `--follow` lookup if a file moved, or attributing a direct line/contract
     conflict), and **never** touch, stage, or `stash` unrelated dirty files.
3. **Action-first; pause ONLY on genuine conflicts.** Do not open pre-execution
   checklist popups. Pause with `ask_question` **only** on missing/ambiguous
   scope, true semantic/contract divergence, overlapping dirty edits on a target
   file to modify, or diverged local vs. remote target history. Never add fake
   `"type in Other"` options (the host UI provides `Other` natively).
4. **Compact clickable basename links & proportional output.** Format code
   references as `[orderService.ts](file:///abs/path/orderService.ts#L42-L58)`
   when supported (`path/orderService.ts:42-58` fallback)—never dump raw
   full-path walls, symbol inventories, or multi-column boilerplate tables.
   Reply in the user's language.

---

## Workflow

### Step 1: Read-Only Sensing & Scope Lock

1. **Inspect local Git state offline** (`git branch --show-current`,
   `git status --porcelain=v1 -b`, `git worktree list`; never run `git fetch`
   unless a named branch is completely absent locally or requested).
2. **Resolve Sync Scope**:
   - **Session Changes (`本次对话的改动`)**: strictly uncommitted hunks and/or
     commit SHAs authored in **this conversation**. **Zero-Edit Guard**: if the
     user requested session changes but zero code edits occurred in this
     conversation, stop and ask via `ask_question` which scope to use
     (`Workspace Uncommitted`, `Branch Commits`, or `Specific Commits/Files`)—never
     silently fall back to `git diff` or `target..source`.
   - **Workspace Uncommitted / Branch Commits (`target..source`) / Explicit
     Commits or Paths**: lock strictly to the requested boundary, excluding
     unrelated parallel dirty files.
3. **Anchor parameters**: If Source, Target, and Scope are unambiguous from the
   prompt, skip asking and proceed immediately. Otherwise ask **only** the
   missing items in **one** `ask_question` card (`(Recommended)` first).

### Step 2: Target Snapshot Audit & Conflict Routing

1. **Resolve `<audit_target_ref>` without false stalls**:
   - Compare `<target>` vs. local `origin/<target>` (`git rev-list --left-right --count <target>...origin/<target>`) if `origin/<target>` exists:
     - **`0 ahead, K > 0 behind`** (local `<target>` simply lags cached remote):
       **do NOT pause**—automatically set `<audit_target_ref> = origin/<target>`
       (and fast-forward `<target>` when landing in an isolated/clean worktree),
       noting the alignment in 1 line in the final summary.
     - **`A > 0 ahead, K > 0 behind`** (genuinely diverged): flag for the single
       decision gate below.
     - Otherwise set `<audit_target_ref> = <target>`.
2. **Classify each cohesive source change unit against `<audit_target_ref>`**
   (using mounted worktree files when matching `<audit_target_ref>`, else
   `git show` / `git grep`):
   - **`Already Covered (Skip)`**: equivalent behavior already exists on
     `<audit_target_ref>`, or a target refactor superseded the root cause with
     all invariants intact.
   - **`Port / Adapt`**: missing or incomplete on `<audit_target_ref>`—plan the
     minimal idiomatic adaptation + companion types/configs/tests.
   - **`True Conflict`**: `<audit_target_ref>` altered contracts/business rules
     incompatible with the change, or a target file to modify has concurrent
     uncommitted edits (`target_dirty_conflict`).
3. **Route**:
   - **Zero `Port / Adapt` & zero `True Conflict`**: stop cleanly in 2–4 lines
     explaining each unit is already covered on `<target>` (with clickable
     basename links where helpful; zero modal popups).
   - **Conflict-Free Fast-Path (`Port / Adapt > 0`, zero conflicts/divergences)**:
     proceed directly to **Step 3**.
   - **Conflict / Divergence Gate**: state the blocking conflict, dirty clash,
     or branch divergence in 3–5 plain lines and open **one** merged
     `ask_question` card (`(Recommended)` option first) before editing.

### Step 3: Safe Isolated Adaptation, Verification & Delivery

1. **Land without disrupting `<source>`**:
   - Already on `<target>` or an existing mounted `<target>` worktree: edit
     **only** the synced files in place.
   - `<target>` unmounted while on `<source>`: create a sibling worktree
     (`../<repo>-sync-<sanitized-target>` from `<audit_target_ref>`—fast-forwarding
     local `<target>` ref if `0 ahead, K behind`), keeping `<source>` untouched
     and never running unprompted `git stash`.
2. **Adapt & run targeted checks**:
   - Apply clean target-native edits + companion types/tests (zero drive-by
     refactoring, zero leftover shims).
   - Run fast, side-effect-free targeted checks (`tsc`, lint, affected unit
     tests) inside the target workspace. If a fresh temporary worktree lacks
     local dependencies (`node_modules`/`.venv`), do **not** install
     unprompted—mark `Not verified` candidly with the exact command to run on
     `<target>`. Never fabricate passing checks, and never `git commit` or
     `git push` unprompted.
3. **Proportional summary & conditional temp-worktree closure**:
   - Deliver one scannable summary scaled to change size (`6–10 lines` for
     small ports; grouped bullets for multi-module ports):
     - **Outcome (1–2 lines)**: `<source> → <target>` (plus temp worktree path
       or `origin/<target>` auto-alignment note if applicable), ported vs.
       skipped counts, and real check status.
     - **Change bullets**: plain functional effect + clickable `[file.ts](file:///abs/path/file.ts#L...)`
       links for ported and skipped units.
     - **Review pointer (conditional, 1 line)**: suggest `/agent-review` **only**
       when non-trivial semantic rewrites occurred or temp-worktree checks were
       skipped.
   - **Closing gate**: stop with **zero popups** when edited in an existing
     workspace. Open **one** `ask_question` card **only** if Step 3.1 created a
     temporary worktree:
     - `(Recommended) Commit synced files on <target> and remove temporary worktree`
     - `Keep uncommitted changes and temporary worktree for manual inspection`
     *(If confirmed: commit **only** the synced target files, run
     `git worktree remove`, and report the commit hash.)*
