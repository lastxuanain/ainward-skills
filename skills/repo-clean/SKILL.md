---
name: repo-clean
description: >-
  Low-friction Git repository and worktree cleanup for merged branches, stashes,
  and scratch files. Triggers: /repo-clean, "repo clean", "clean workspace",
  "cleanup leftovers", "清理仓库", "清理工作区", "清理 worktree", "清理中间产物".
license: MIT
metadata:
  author: ainward
  version: "2.0.0"
---

# Repo Clean (低心智负担仓库与关联工作区清理)

Clean up leftover **worktrees, local branches, stashes, and ephemeral AI
scratch/plan files** after PR merges or parallel multi-agent tasks—separating
100% deterministic cleanups from items needing judgment so you decide in
seconds without auditing raw Git trivia.

## When to use

- Tidying stale checkouts, merged/squashed branches, stashes, or temporary AI
  planning files after shipping PRs or running parallel agent threads.
- **Adaptive scope**: scan all 4 categories (`worktrees`, `branches`, `stashes`,
  `scratch files`) on `/repo-clean` or workspace-wide requests; scan **only**
  `worktrees + branches` when the user asks specifically to clean branches or
  worktrees.
- Never delete remote `origin` branches, active workspace build/dependency
  caches (`node_modules/`, `.venv/`, `dist/`, `build/`, `target/`, `.next/`),
  or paths outside the current repo and `git worktree list`.

---

## Protection floor & core rules

1. **Unconditional protection (never delete, never clutter the list with `🔴` rows)**:
   - Current active worktree, `locked` worktrees (never remove without explicit
     warning), current `HEAD`, `<base_branch>`, `main`, `master`, `develop`,
     `dev`, `release/*`, and all remote `origin/*` refs;
   - All Git-tracked files (`git ls-files`), `.env*`, active workspace
     dependency/build caches, and persistent AI/editor configs (`CLAUDE.md`,
     `AGENTS.md`, `GEMINI.md`, `.cursorrules`, `.cursor/rules/**`,
     `.claude/settings*.json`, `.claude/skills/**`, `.agents/**`).
2. **P0 Deterministic `🟢` vs. AI-Digested `🟡` Boundary**:
   - **`🟢 Safe to Clean` is strictly reserved for 100% deterministic,
     zero-ambiguity items** (all inactive `> 10 min` so hot parallel threads
     are never touched).
   - **Every heuristic semantic match** (such as squash/ported branches whose
     patch IDs differ, or untracked AI plan docs) **MUST stay in `🟡`** with a
     1-line plain-language digest + `(推荐：删)` or `(推荐：留)`—never
     force-delete heuristic guesses inside `🟢`.
3. **Offline read-only scan first & clean formatting**: Never run `git fetch`
   unprompted. Use compact clickable `[file.md](file:///abs/path/file.md)`
   links (`path/file.md` fallback) for file items; never add fake `"type in Other"`
   options in `ask_question`. Reply in the user's language.

---

## Workflow

### Step 1: Offline Scan & Classification

Anchor the repo root, shared `.git` dir, and `<base_branch>` (`origin/HEAD` →
`main` / `master` / `HEAD`), then classify non-protected items read-only:

1. **Worktrees (`git worktree list --porcelain`)**:
   - **`🟢`**: `prunable` missing directories, or clean, unlocked worktrees
     (`> 10 min` idle) detached at `<base_branch>` or mounting a
     deterministically merged branch (`du -sh` noted).
   - **`🟡`**: dirty, `locked`, active `<= 10 min`, or mounting an unmerged
     branch—inspect `status` / `diff --stat` to write a 1-line summary + lean.
2. **Local branches (`refs/heads`)** *(include branches mounted inside `🟢`/`🟡` candidate worktrees so both clean in one pass)*:
   - **`🟢` (100% deterministic, `> 10 min` idle)**: listed in
     `git branch --merged <base_branch>`, upstream `[gone]` with **0** commits
     ahead of `<base_branch>`, or `git cherry <base_branch> <branch>` having
     **zero `+` lines** (all patches equivalent on `<base_branch>`).
   - **`🟡` (`git cherry` has `+` commits or `<= 10 min` hot)**: inspect
     `git log -n 8 --oneline <base_branch>..<branch>` and `git diff --stat`,
     spot-checking target files on `<base_branch>`. If the capability clearly
     landed via squash merge or semantic port (`> 10 min` idle), mark **`🟡`
     with `(推荐：删 — 已 Squash/语义合入)`**; otherwise mark **`🟡` with
     `(推荐：留)`** (or `(推荐：删)` if clearly obsolete spike).
3. **Stashes (`git stash list`)** *(skip when user scoped to branches/worktrees only)*:
   - **`🟢`**: `> 10 min` idle and full patch (`git stash show -p` + `^3`)
     already exists identically on `<base_branch>` or `HEAD`.
   - **`🟡`**: contains unique/partial unapplied edits or `<= 10 min` hot (1-line
     summary of changed files/intent + `(推荐：删 / 留)`).
4. **Ephemeral AI scratch & temp files** *(current workspace + kept worktrees only; skip when user scoped to branches/worktrees)*:
   - **`🟢`**: hard temp leftovers (`*.orig`, `*.rej`, `*.tmp`, `*.bak`,
     `*.swp`) idle `> 10 min`.
   - **`🟡` (narrow AI scratch match ONLY)**: untracked items matching
     `.claude/worktrees/`, `.claude/plans/`, `.cursor/plans/`, `.worktrees/`,
     `docs/plans/`, `PLAN*`, `ANALYSIS*`, `WALKTHROUGH*`, `REVIEW*`, `*推演*`,
     `*排查*` (**do NOT flag** general docs like `SPEC*`, `DESIGN*`, `TODO*`,
     `NOTES*`). Read at most the first ~50 lines per file (cap deep reads at 10
     files; summarize any excess by filename/mtime), cross-check against the
     codebase, and write a 1-line digest + `(推荐：删 — 方案已落地)` or
     `(推荐：留 — 尚未实现)`.

### Step 2: Dual-Zone Summary & Single Decision Card

- **Clean exit (`🟢 = 0` and `🟡 = 0`)**: confirm clean in 2 lines (mention
  optional `git fetch --prune` only if remotes exist; zero popups).
- **Numbered report (`#1..#N`)**:
  - **Headline (1 line)**: `扫描完成：共 X 项可归整（约释放 Y MB）｜ 🟢 确定安全 A 项 ｜ 🟡 需拍板 B 项`
    *(append a 1-line passive tip only if `.git` exceeds 500 MB)*.
  - **`🟢 确定安全（A 项）`** *(omit if `A = 0`)*: compact grouped bullets (`#ID` +
    short name/clickable link + notable size + 2–4 word reason).
  - **`🟡 需拍板（B 项）`** *(omit if `B = 0`)*: 1 bullet per item (`#ID [类别] 名称 — 1 句内容摘要 → (推荐：删 / 留)`).
- **Single `ask_question` card** *(adapt cleanly to `A`, `B`, and count `K` of `🟡` items marked `推荐：删`; custom `#ID` edits or previews work natively via `Other` or chat)*:
  - `(Recommended) 清理全部 🟢 + 推荐删除的 🟡（#...，共 A+K 项）` *(when `B > 0` and `K > 0`; otherwise `(Recommended) 清理全部 🟢 安全项（共 A 项）`, or `(Recommended) 保留全部，暂不清理` when `A = 0, K = 0`)*
  - *(Include when `A > 0` and `B > 0` and `K > 0`)* `仅清理全部 🟢（共 A 项），保留全部 🟡`
  - *(Include when remotes exist)* `先执行 git fetch --prune 刷新远端状态后再重扫`
  - `暂不清理`

### Step 3: Dependency-Safe Execution & Recovery Receipt

1. **Snapshot Commit SHAs first**: run `git rev-parse` for every branch and
   stash slated for deletion before mutating anything.
2. **Execute strictly in order**:
   1. **Worktrees**: `git worktree remove <path>` (`--force` only on explicitly
      approved dirty worktrees), followed by `git worktree prune`.
   2. **Branches**: `git branch -d` for merged branches; `git branch -D` only
      for explicitly confirmed `🟡` branches.
   3. **Stashes**: drop selected stashes in **descending index order**
      (`stash@{4}` before `stash@{1}`) so indices never shift.
   4. **Scratch / temp files** *(skipping paths inside removed worktrees)*: move
      untracked `.md` scratch files to **OS Trash** (`trash` / Finder on macOS,
      `gio trash` / `trash-put` on Linux; if Trash is unavailable in a headless
      environment, **pause before permanent `rm`** on `.md` docs); remove
      confirmed `*.orig`/`*.rej`/`*.tmp`/`*.bak` cleanly.
   5. **Never run `git gc --prune=now`** so deleted Git objects remain
      recoverable.
3. **Receipt**: print cleaned counts + freed space, any retained `🟡` items,
   and—whenever branches or stashes were deleted—a copy-pasteable **Recovery
   Commit SHA** block (`git branch <name> <sha>` / `git stash apply <sha>`).
