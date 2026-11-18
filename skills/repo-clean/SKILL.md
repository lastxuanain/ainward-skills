---
name: repo-clean
description: >-
  Low-cognitive-load repository hygiene and workspace cleanup workflow for Git
  repositories after remote merges or parallel multi-agent tasks. Scans the
  current repository and all linked git worktrees read-only and offline,
  pre-reads untracked AI plans/scratch docs, stashes, and unmerged branches to
  judge semantic landing against the base branch, and delivers a Result-First
  dual-zone summary (auto-folding protected core assets, keeping safe cleanups
  compact, and writing 1-line AI-digested verdicts with clear keep/delete calls
  for uncertain items). Executes in safe dependency order with tiered
  recoverability (OS Trash for untracked docs, recovery Commit SHAs for deleted
  branches/stashes).
  Triggers: /repo-clean, "repo clean", "clean workspace", "clean branches",
  "clean worktrees", "cleanup leftovers", "清理仓库", "清理工作区", "清理分支",
  "清理 worktree", "清理中间产物", "清理推演文件", "仓库清理".
license: MIT
compatibility: >-
  Works best with a structured question tool (e.g. ask_question, AskUserQuestion),
  Git shell, and file read/inspect tools; falls back gracefully to numbered
  plain-text options when structured prompts are unavailable.
metadata:
  author: Ainward
  version: "1.0.0"
  status: experimental
  category: "repo-hygiene, worktree-cleanup, context-management, software-engineering"
  verified-agents: "antigravity"
---

# Repo Clean (低心智负担仓库清理与并行残余归整)

Clean up leftover **worktrees, local branches, stashes, and ephemeral AI
planning/scratch artifacts** after remote branch merges or parallel multi-thread
agent tasks—reclaiming disk space and stripping AI context clutter **without
dumping raw Git trivia for you to audit manually**.

## When to use

- After merging feature/PR branches (via GitHub/GitLab squash/rebase merge or
  `/code-sync`) when stale local branches, stashes, temporary worktrees, and
  untracked planning/analysis docs accumulate.
- After running parallel AI coding threads/subagents when finished worktrees,
  intermediate deduction notes (`PLAN*.md`, `ANALYSIS*.md`, `docs/plans/`), or
  merge conflict leftovers (`*.orig`, `*.patch`) bloat disk usage and pollute
  context searches.
- Before starting a fresh task when you want a fast, safe inventory and cleanup
  of non-essential workspace leftovers.

Do **not** use this skill to delete remote `origin` branches (`git push --delete`),
prune active build/dependency caches (`node_modules`, `.venv`, `dist`) inside
the active workspace, or wipe cross-project directories outside `git worktree list`.

## Core principles

1. **Repo-centric boundary (`以当前 Git 仓库为核心边界`).**
   Scope discovery strictly to the current Git repository **plus** every linked
   worktree registered in `git worktree list` (even when mounted outside the
   repo directory, such as `../<repo>-sync-*`, `.worktrees/*`,
   `~/.claude/worktrees/*`, or `~/.codex/worktrees/*`). Never scan unrelated
   projects or external global agent directories (`~/.claude/plans`,
   `~/.gemini/antigravity/brain`, etc.).

2. **Offline read-only sensing first (`纯本地只读快扫优先`).**
   Perform all scanning, semantic landing checks, and disk measurements
   read-only and **offline**—never run `git fetch` automatically. If remote
   branch merge state might be stale locally, mention it briefly and offer
   `git fetch --prune` as an optional action inside the decision gate.

3. **AI pre-digestion & minimum cognitive load (`AI 后台替读语义判死，压缩人工审阅`).**
   Never force the user to open files or decipher branch/stash names themselves:
   - Internally read untracked plan/analysis docs, stash diffs, and unmerged
     branch commits, and compare them semantically against `<base_branch>` /
     current `HEAD`.
   - **Auto-promote settled work directly to `🟢 Safe to Clean`**, even if
     finished only minutes ago: clean merged/squash-merged/`code-sync`-ported
     branches & worktrees, stashes whose diffs already exist in `<base_branch>`
     or `HEAD`, and untracked plan/scratch docs whose implementation has
     already landed or been superseded.
   - **Reserve `🟡 Review Needed` strictly for genuine uncertainty or live
     concurrency risk**: unmerged unique commits, dirty uncommitted worktrees,
     unapplied stash changes, unimplemented plan/idea docs, `locked` worktrees,
     or files actively modified within the **last ~10 minutes** (hot concurrent
     thread guard).
   - For **every `🟡` item**, write **one crisp plain-language verdict**: what
     is inside + why it is uncertain + a clear lean (`推荐：删` or `推荐：留`).

4. **Strict protection & low-noise omission (`硬保护底线与保护项折叠`).**
   - **Never** delete Git-tracked formal files (`git ls-files`), `.env*`, or
     persistent AI project rules/configs (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`,
     `.cursorrules`, `.cursor/rules/**`, `.claude/settings*.json`,
     `.claude/skills/**`, `.agents/**`).
   - **Never** list normal `.gitignore` build/dependency directories in the main
     workspace (`node_modules/`, `.venv/`, `dist/`, `build/`, `target/`,
     `.next/`) as cleanup items *(removing an obsolete worktree naturally
     reclaims that worktree's own local caches)*.
   - **Never** suggest deleting the current active worktree, `locked`
     worktrees (without explicit warning), protected branches (`main`, `master`,
     `develop`, `dev`, `release/*`, `HEAD`), or remote `origin` branches.
   - Fold protected assets into **one summary line** instead of bloating the
     review list with `🔴` rows.

5. **Result-First dual-zone presentation (`内严外简双区视图`).**
   Present one clean numbered report (`#1..#N`):
   - **1-line Headline** (total items, reclaimable space, `🟢` vs `🟡` counts)
   - **Compact `🟢` section** (short name + size + 2–5 word tag only—zero full
     path/SHA dumps)
   - **High-signal `🟡` section** (1 line per item with AI-digested summary +
     `推荐：删 / 留`; **omit this section completely when `🟡 = 0`**)
   - **1-line Protection Footer** + `"展开细节"` on-demand expansion hint.

6. **Tiered recoverable execution in safe dependency order (`分层可逆清理`).**
   Never delete anything without explicit confirmation. Execute confirmed items
   strictly in order: **Worktrees → Branches → Stashes → Intermediate Files →
   (Optional) `remote prune`**:
   - Remove worktrees first so branches mounted inside them can be deleted in
     the same pass;
   - Record full **Commit SHAs** for every deleted branch and dropped stash in
     the final receipt (and drop stashes in **descending index order** so indices
     never shift mid-loop);
   - Move untracked scratch/plan documents to the **OS Trash** whenever
     available (only falling back to permanent `rm` after explicit confirmation
     if Trash is unavailable in a headless sandbox);
   - Never run `git gc --prune=now` automatically (preserving SHA recovery);
     only print a passive tip if `.git` exceeds ~500 MB.

7. **Reply in the user's language.**

## Host adaptation

- **Question gate:** if the host provides a structured question tool (e.g.
  `ask_question` in Antigravity, `AskUserQuestion` in Claude Code), use it so
  the user can confirm in one click or customize IDs in `Other`. Otherwise,
  output concise numbered options and end your turn immediately to wait.
- **Detail expansion:** retain full filesystem paths, mtimes, commit lists, and
  file previews in working memory so `"展开细节"` or `"预览 #X"` answers
  immediately without re-scanning.

---

## Workflow

### Step 1: Silent Read-Only Scan & AI Semantic Pre-Digestion (`静默只读扫描与后台替读`)

Run all checks strictly read-only and offline:

1. **Anchor Repo & Base Branch**:
   - `git rev-parse --show-toplevel` (current worktree root) and
     `git rev-parse --git-common-dir` (shared `.git` dir).
   - Detect `<base_branch>`: check `git symbolic-ref --short refs/remotes/origin/HEAD`
     (strip `origin/`), falling back to `main`, `master`, or current `HEAD`.
   - Record current active worktree path and current `HEAD` branch so both
     stay strictly protected.

2. **Scan Linked Worktrees (`git worktree list`)**:
   - Run `git worktree list --porcelain` to parse every worktree path, `HEAD`
     SHA, mounted `branch`, `detached`, `locked`, and `prunable` state.
   - Skip the current active worktree (protected).
   - If `prunable` (directory already missing on disk): mark as **`🟢`**
     (`失效记录，prune 即可`).
   - For each remaining existing worktree directory:
     - Check dirty status: `git -C <wt_path> status --porcelain=v1`.
     - Check disk size: `du -sh <wt_path>` *(note internally if large caches like
       `node_modules` inflate it)*.
     - Check recent write activity: inspect latest file mtime in `<wt_path>`
       (excluding `.git`) to detect hot concurrent edits (`<= 10 minutes`).
     - Evaluate mounted branch landing against `<base_branch>` (see #3 below).
     - Classify:
       - Clean + unlocked + not hot (`> 10 min`) + (detached at `<base_branch>`
         or branch landed / temporary `sync/*` already landed) → **`🟢`**
       - `locked`, dirty edits, hot (`<= 10 min`), or unmerged unique commits →
         **`🟡`** *(read `git -C <wt_path> diff --stat` / unmerged commit logs
         so you can summarize in 1 sentence what work lives inside and whether
         it looks finished/redundant or valuable!)*.

3. **Scan Local Branches (`refs/heads`)**:
   - Run `git for-each-ref --sort=-committerdate --format='%(refname:short)|%(objectname:short)|%(objectname)|%(upstream:short)|%(upstream:track)|%(committerdate:relative)|%(committerdate:unix)' refs/heads`.
   - **Protected skip (`🔴`)**: `<base_branch>`, `main`, `master`, `develop`,
     `dev`, `release/*`, current `HEAD`, and any branch mounted in a *kept*
     worktree. *(Note: if a branch is mounted in a worktree ALSO classified `🟢`
     or `🟡`, still list the branch as a candidate so removing the worktree +
     branch can happen in one pass!)*
   - **3-Layer Landing Detection (beyond naive `git branch --merged`)**:
     1. *Traditional merge*: branch appears in `git branch --merged <base_branch>`. → **`🟢`** (`已合入`).
     2. *Upstream gone + patch check*: `%(upstream:track)` is `[gone]` OR
        `git cherry <base_branch> <branch>` has zero `+` lines (all patches
        already on `<base_branch>`). → **`🟢`** (`上游已删/补丁等效合入`).
     3. *Semantic squash/`code-sync` check*: if `git cherry` still shows `+`
        commits, inspect `git log -n 8 --oneline <base_branch>..<branch>` and
        `git diff --stat <base_branch>...<branch>`, then spot-check the target
        files on `<base_branch>`:
        - If the exact capability/fix is clearly already present on `<base_branch>`
          (e.g. from GitHub Squash Merge or `/code-sync` adaptation) and not
          hot (`> 10 min`) → **`🟢`** (`已 squash/语义合入`).
        - Otherwise → **`🟡`** (summarize the unmerged commits in 1 human
          sentence + `推荐：留` if active/valuable feature WIP or `推荐：删` if
          abandoned/obsolete test branch).
   - Also check `git remote` and note offline staleness (do not run `git fetch`).

4. **Scan Stashes (`git stash list`)**:
   - Run `git stash list --format='%gd|%H|%ct|%cr|%gs'`.
   - For each stash, inspect `git stash show --stat <ref>` and `git stash show -p <ref>`
     (and untracked files inside stash `<ref>^3` if present):
     - Check whether all modified files/hunks already exist identically or have
       been superseded on `<base_branch>` / current `HEAD`.
     - If already landed/superseded (and not hot `<= 10 min`) → **`🟢`**
       (`改动已存在/已过时`).
     - If unique unapplied edits remain → **`🟡`** (summarize in 1 sentence what
       the stash changes—e.g. *"暂存了订单超时重试的半成品改动 (2 文件)"*—plus
       `推荐：删` or `推荐：留`).

5. **Scan Intermediate Artifacts (`推演文件、方案与临时产物`)**:
   - Scan the current workspace and any *kept* worktrees *(skip files inside
     worktrees already marked `🟢`, since removing the worktree removes them
     automatically)*.
   - Check `git status --porcelain=v1 -uall` (untracked `??` entries) plus
     **targeted** ignored entries via
     `git ls-files --others --ignored --exclude-standard --directory` filtered
     strictly to ephemeral patterns—**never** descend into `node_modules/`,
     `.venv/`, `venv/`, `dist/`, `build/`, `out/`, `target/`, `.next/`,
     `.nuxt/`, `.git/`, or touch `.env*`.
   - **Strict AI Config Protection**: unconditionally skip `CLAUDE.md`,
     `AGENTS.md`, `GEMINI.md`, `.cursorrules`, `.cursor/rules/**`,
     `.claude/settings*.json`, `.claude/skills/**`, `.agents/**`, and **any**
     Git-tracked file (`git ls-files`).
   - Match candidates across 3 patterns:
     - **A. Hard Temp / Merge Leftovers**: `*.orig`, `*.rej`, `*.patch`,
       `*.diff`, `*.bak`, `*.tmp`, `*.swp`, `tmp/`, `.tmp/`, `scratch/` →
       **`🟢`** (unless hot `<= 10 min` → **`🟡`**).
     - **B. Ephemeral AI Working Dirs**: `.claude/worktrees/`, `.claude/plans/`,
       `.cursor/plans/`, `.agent/`, `.worktrees/`, `docs/plans/`,
       `docs/superpowers/`, `plans/`.
     - **C. Untracked Plan / Deduction / Walkthrough Docs**: untracked `.md` /
       `.txt` files matching planning/reasoning patterns (`PLAN*`, `DESIGN*`,
       `ANALYSIS*`, `SPEC*`, `NOTES*`, `TODO*`, `REVIEW*`, `SUMMARY*`,
       `WALKTHROUGH*`, `*方案*`, `*推演*`, `*分析*`, `*排查*`, `*总结*`,
       `*草稿*`).
   - **Mandatory AI Pre-Read for B & C**:
     Read the header/key sections (~40–80 lines) of each matched document or
     directory summary, and cross-check the mentioned files/symbols/features
     against the codebase:
     - If the plan/analysis corresponds to work **already implemented/committed**
       or an expired debug/review note (and not hot `<= 10 min`) → **`🟢`**
       (`方案已落地` / `过程推演稿`).
     - If it describes **unstarted/unimplemented proposals**, ambiguous personal
       notes, or was modified **`<= 10 min` ago** → **`🟡`** (1-line content
       digest + `推荐：留` or `推荐：删`).

6. **Optional `.git` Size Check**:
   - Check `du -sh <git_common_dir>`. Never list `.git` as a cleanup item;
     keep note only if `> 500 MB`.

---

### Step 2: Result-First Dual-Zone Report (`极简双区呈报`)

1. **Zero-Leftover Early Exit**:
   If `🟢 = 0` and `🟡 = 0`:
   - Reply concisely in 2–3 lines confirming the repository and linked
     worktrees are clean (`🔴 已保护主分支与配置文件`).
   - If the repo has remotes and the user may have just merged online PRs,
     offer a single optional `ask_question` or 1-line note for `git fetch --prune`;
     otherwise stop cleanly with zero popups.

2. **Numbered Dual-Zone Report (`#1..#N`)**:
   Assign contiguous IDs `#1..#N` across all `🟢` and `🟡` items. Present **only**:
   - **1-Line Headline**:
     `扫描完成：共发现 X 项可归整（预计释放约 Y MB）｜ 🟢 安全清理 A 项 ｜ 🟡 需拍板 B 项`
   - **Protection Summary (1 line)**:
     `🔴 已自动保护：<base_branch>、当前工作区、所有 Git 跟踪文档及 CLAUDE.md / AGENTS.md 等持久化配置。`
   - **`🟢 建议直接清理（A 项，已确认合入/落地或纯临时残留）`**:
     Compact grouped bullets (omit empty categories). Keep each entry to
     **`#ID` + short name + size (when notable) + 2–5 word reason**:
     - `Worktree`：`#1 ../repo-sync-main` (480 MB · 已合入主分支)
     - `本地分支`：`#2 feat/auth-retry`、`#3 fix/timeout` (均已合入)
     - `Stash`：`#4 stash@{0}` (改动已存在于当前分支)
     - `中间产物`：`#5 PLAN-auth.md` (方案已落地)、`#6 foo.ts.orig` (合并残留)
     *(Zero full paths, zero timestamps, zero commit SHAs here.)*
   - **`🟡 需你拍板（B 项 — AI 已替你读完内容并给出建议）`** *(Omit entire section when `B = 0`!)*:
     One concise bullet per item:
     - `#7 [Worktree] ../repo-wt-pay (320 MB · 5 分钟前活跃) — 含 2 处未提交的退款弹窗改动，疑似仍在运行或刚中断 → 推荐：留`
     - `#8 [推演文档] docs/plans/cache-v2.md (12 KB) — 写了 Redis 二级缓存方案，代码中尚未发现对应实现 → 推荐：留`
     - `#9 [Stash] stash@{1} — 仅剩 1 条调试 console.log，其余改动已合入 → 推荐：删`
   - **Footer Hint (1 line)**:
     `回复“展开细节”或“预览 #编号”可看完整路径/修改时间/原文摘要；若刚合并完线上 PR，可在下方选择先刷新远端状态。`
     *(Append a 1-line `.git` size note only if `.git > 500 MB`.)*

---

### Step 3: Single-Step Low-Friction Decision Gate (`单步决策卡`)

Immediately open **one** `ask_question` card (or numbered text options) adapted
to `(A, B)`:

- **When `A > 0` and `B == 0`**:
  - `(Recommended) 一键清理全部 A 项 🟢 安全产物`
  - `先执行 git fetch --prune 刷新远端状态后再重扫`
  - `调整清单或查看细节（在 Other 输入，如“排除 #2”或“展开细节”）`
  - `仅盘点，暂不清理（退出）`
- **When `B > 0` and AI recommended deleting `K > 0` of the `🟡` items**:
  - `(Recommended) 一键清理全部 🟢（A 项）+ AI 推荐可删的 🟡（#...，共 A+K 项）`
  - `仅清理全部 🟢（A 项），保留全部 🟡`
  - `自定义调整或预览某项（在 Other 输入，如“清绿标 + #8”、“排除 #2”、“预览 #7”、“先 fetch --prune”）`
  - `仅盘点，暂不清理（退出）`
- **When `B > 0` and AI recommended keeping ALL `🟡` items (`K == 0`)**:
  - `(Recommended) 仅清理全部 🟢（A 项），保留全部 🟡` *(or `保留全部，暂不清理` if `A == 0`)*
  - `自定义指定编号或预览某项（在 Other 输入，如“加上 #7”、“预览 #8”、“先 fetch --prune”）`
  - `仅盘点，暂不清理（退出）`

**Loop handling**:
- If the user asks to `"展开细节"` or `"预览 #X"`: display the requested full
  paths, mtimes, commit summaries, or file/diff excerpts cleanly, then reopen the
  single-step decision gate once more.
- If the user picks `git fetch --prune`: run `git fetch --prune`, re-run Step 1
  & Step 2 cleanly, and reopen Step 3.
- If the user chooses exit: stop cleanly with zero mutations.

---

### Step 4: Safe Tiered Execution & Recovery Receipt (`分层顺序清理与可挽救回执`)

Execute **strictly** the confirmed `#ID` set in exact dependency order:

1. **Snapshot Recovery Metadata Before Any Git Ref Deletion**:
   - For every branch to delete: capture `git rev-parse <branch>`.
   - For every stash to drop: capture `git rev-parse <stash_ref>`.

2. **Execute in Safe Order**:
   1. **Worktrees (`git worktree remove`)**:
      - Use `git worktree remove <path>` for clean worktrees.
      - Use `git worktree remove --force <path>` **only** for dirty/unmerged
        worktrees explicitly approved by the user.
      - Run `git worktree prune` afterward to clear stale metadata.
   2. **Local Branches (`git branch -d / -D`)**:
      - Delete traditional merged branches with `git branch -d <branch>`.
      - Use `git branch -D <branch>` only for explicitly confirmed
        squash-merged / `code-sync` / `🟡` unmerged branches.
      - *(Never touch remote `origin` branches.)*
   3. **Stashes (`git stash drop`)**:
      - **CRITICAL**: Sort selected stash indices **descending** (e.g. drop
        `stash@{4}` before `stash@{1}`) so earlier drops never shift later
        stash indices!
   4. **Intermediate Files (Tiered Trash / Delete)**:
      - Skip files whose parent worktree was already removed in step 1.
      - **Untracked plan/analysis/note documents**: move to **OS Trash** first
        when available:
        - macOS: check `command -v trash` (`trash -- <abs_path>`), else
          `osascript -e 'tell application "Finder" to delete POSIX file "<abs_path>"'`.
        - Linux: `gio trash -- <abs_path>` or `trash-put -- <abs_path>`.
        - **Headless/No-Trash Guard**: if OS Trash fails or is unavailable
          (common in headless sandboxes), **do not silently `rm`** user
          plan/note documents—either surface a single confirmation asking to
          permanently `rm` those files or skip them safely!
      - **Pure generated leftovers** (`*.orig`, `*.rej`, `*.tmp`, `*.swp`,
        empty temp dirs): move to OS Trash if working cleanly, or remove with
        `rm -rf` once confirmed in Step 3.
   5. **Optional `git remote prune origin`**: run only if the user opted to
      prune stale remote tracking refs.
   6. **Do NOT run `git gc --prune=now`** so deleted branch/stash SHAs remain
      recoverable in the object database / reflogs.

3. **Deliver Concise Verification & Recovery Receipt**:
   - Verify final health (`git status -sb`, `git worktree list`).
   - Output compact receipt:
     - **Cleaned counts & reclaimed space**: e.g. `已清理：Worktree X 个、本地分支 Y 条、Stash Z 条、中间文件 W 份（约释放 XXX MB；未跟踪文档已移入回收站）`
     - **Skipped / Retained**: brief note on `🟡` items kept (if any) and any
       item that failed to remove with the exact error reason.
     - **Recovery SHAs** *(whenever any branch or stash was deleted)*:
       compact code block listing `git branch <name> <sha>` /
       `git stash apply <sha>` so mistakes are effortlessly reversible.

---

## Anti-patterns

- Dumping raw `git status`, full filesystem paths, timestamps, and `🔴`
  protected items in the default view instead of Result-First dual-zone
  summaries.
- Escalating freshly finished (`< 24h`) clean/merged worktrees or landed plans
  into `🟡` instead of reading them semantically and clearing them via `🟢`.
- Leaving `🟡` items unexplained (*"unknown file `PLAN.md`"*) without AI
  pre-reading their contents and stating a concrete `推荐：删 / 留` call.
- Deleting Git-tracked formal files, `CLAUDE.md` / `AGENTS.md` / `GEMINI.md` /
  `.cursor/rules`, or active `node_modules` / `.env` files.
- Running `git push origin --delete`, running unprompted `git fetch`, or
  running `git gc --prune=now` (which destroys branch/stash SHA recovery).
- Dropping multiple stashes in ascending order (`stash@{0}` then `stash@{1}`),
  deleting a branch before removing its mounted worktree, or silently `rm`-ing
  untracked plan documents when OS Trash fails without warning.
