---
name: code-sync
description: >-
  Interactive, intent-driven cross-branch code synchronization and semantic porting
  workflow. Anchors source branch, target branch, and sync scope (current session
  changes, workspace uncommitted changes, source branch commits, or specific
  commits/files), extracts true fix/feature semantics, audits the target branch
  across four states (Already Synced, Superseded by Refactor, Missing/Regressed,
  Semantic Conflict) without blind cherry-picking or mechanical copy-pasting,
  gates on a Minimal Sync Plan, re-adapts changes to the target branch's current
  architecture and SSOT with 3D call-chain safety, and verifies via a Sync
  Sign-Off Table.
  Triggers: /code-sync, "code sync", "sync to branch", "port changes to",
  "semantic merge", "merge to branch", "sync code", "代码同步", "代码合并",
  "同步到分支", "合并到分支", "把改动同步到", "同步代码", "向目标分支同步".
license: MIT
compatibility: >-
  Works best with a structured question tool (e.g. ask_question, AskUserQuestion)
  plus Git shell and file read/edit tools; falls back to numbered plain-text
  options when structured prompts are unavailable.
metadata:
  author: Ainward
  version: "1.0.0"
  status: experimental
  category: "code-sync, semantic-merge, branch-porting, software-engineering"
  verified-agents: "antigravity"
---

# Code Sync (语义化代码同步与跨分支合并)

Synchronize bug fixes, features, or refactors from a source context to a target
branch **by true engineering intent rather than mechanical patch replay**. Instead
of running blind `git cherry-pick` or copy-pasting outdated code onto a diverged
branch, extract what the source change actually solves, audit the target branch's
latest architecture across four semantic states, align with the user via a
**Minimal Sync Plan (`最小改动清单`)**, and re-adapt only what is genuinely needed.

## When to use

- Porting or syncing changes made in the **current conversation**, **dirty working
  tree**, **diverged feature/hotfix/release branch**, or **specific commits/files**
  into another branch (such as `main`, `develop`, or a release branch).
- Synchronizing fixes across branches that have undergone structural refactoring,
  file moves, or Single Source of Truth (SSOT) changes where raw `git merge` or
  `git cherry-pick` would conflict—or worse, apply cleanly in syntax while
  introducing silent regressions.

Do **not** use this skill as a mechanical `git merge` wrapper when the user
explicitly asks to run a raw `git merge --ff-only` or branch topology operation
without code inspection.

## Core principles

1. **Semantic intent & target architecture over mechanical copying (`语义与目标架构优先`).**
   **Never** blindly `git cherry-pick`, `git apply`, or copy-paste legacy hunks
   verbatim onto the target branch. Extract the root problem, behavioral
   contract, and invariants of each source change first, then adapt it
   idiomatically to the target branch's **current module boundaries, shared
   abstractions, and Single Source of Truth (SSOT)**.
2. **Evidence-backed 4-state semantic audit (`拿双端代码证据做四类状态盘点`).**
   Audit every cohesive logical unit against the target branch with concrete file
   and line-range proof:
   - `Already Synced (已同步)` — equivalent behavior already exists on target.
   - `Superseded by Refactor (已被后续重构覆盖)` — target refactored the module so
     the root cause no longer exists or is handled by a new mechanism *(verify
     the original failure/business path end-to-end; never assume a moved or
     deleted file means the issue was solved)*.
   - `Missing or Regressed — Needs Adaptation (仍缺失或存在回归，需重适配)` — not
     yet present on target, partially synced, or broken again by later target
     changes; requires minimal target-native adaptation.
   - `Semantic Conflict / Product Divergence (存在语义冲突或业务分歧，待拍板)` —
     target intentionally changed contracts, state machines, or business rules
     in a way incompatible with source; surface concrete options instead of
     guessing.
3. **Zero-disruption read-only analysis (`分析期零切分支、零现场破坏`).**
   During parameter sensing and cross-branch analysis, **never** run `git checkout`,
   `git stash`, `git merge`, or unprompted `git fetch`. Read the target branch via
   read-only Git inspection (`git show <target_ref>:<path>`,
   `git grep <pattern> <target_ref>`, `git log <target_ref> -- <path>`, or an
   existing mounted `git worktree`).
4. **Five consistency invariants & 3D regression safety (`五维一致性与三维防回归`).**
   Every adapted unit on the target branch must keep five dimensions aligned:
   - **Main Execution Flow (`主链路闭环`)** — entrypoint/UI → validation/auth →
     domain logic → persistence/RPC → response/feedback.
   - **Data State & SSOT (`数据状态与单一事实源`)** — field names, types,
     nullability, defaults, units, and state-transition guards.
   - **Side Effects (`副作用一致`)** — cache invalidation, events/queues,
     transactions, hooks/effects, and logging/metrics.
   - **Error & Failure Semantics (`异常处理与反静默兜底`)** — rollback, accurate
     error propagation, and zero silent `catch {}` or unauthorized fallback values.
   - **3D Call-Chain Safety on Target (`目标分支三维调用链安全`)** — verify
     upstream callers, downstream callees, and lateral shared-component peers
     *on the target branch* to prevent `"fix A, break B"` regressions.
5. **Single-step merged gates — human stays in command (`单步合并门禁，绝不连环弹窗`).**
   - Collect only missing/ambiguous inputs in **one** opening prompt (skipping
     entirely when all three inputs are already explicit).
   - Gate execution on the **Minimal Sync Plan (`最小改动清单`)**, merging plan
     approval, any semantic-conflict decisions, remote-freshness alignment, and
     cross-branch landing mode (`worktree` vs. `stash + checkout`) into **one**
     confirmation turn before mutating files.
   - Never run `git commit` or `git push` unprompted; open a post-sync cleanup
     gate **only** when this run created a temporary `git worktree` or `git stash`.
6. **Reply in the user's language.**

## Host adaptation

- **Question gate:** if the host provides a structured question tool (e.g.
  `ask_question` in Antigravity, `AskUserQuestion` in Claude Code), use it—grouping
  multiple simultaneous choices into a single multi-question card so the user
  submits once. Otherwise, present concise numbered options in plain text. Either
  way, **end your turn immediately after asking.**
- **Code references:** for files checked out on disk (in the current workspace or
  a mounted worktree), use clickable host links when supported (e.g.
  `[order.ts](file:///abs/path/order.ts#L42-L58)`), otherwise `path/to/order.ts:42-58`.
  For target-branch files inspected purely via Git refs without a local checkout,
  format clearly as `<target_ref>:path/to/order.ts#L42-L58`.

---

## Workflow

### Step 1: Fast Read-Only Sensing & On-Demand Input Anchoring (`静默预检与三要素智能锚定`)

1. **Run fast local Git sensing in a single read-only command** *(do **not** run
   `git fetch` automatically)*:
   - Current branch / HEAD: `git branch --show-current` (and `git rev-parse --short HEAD`).
   - Working tree status: `git status --porcelain=v1 -b`.
   - Mounted worktrees: `git worktree list` *(note if candidate source or target
     branches are already checked out in sibling worktrees)*.
   - Local & cached remote-tracking branches sorted by recency:
     `git for-each-ref --sort=-committerdate --format='%(refname:short) %(objectname:short) %(upstream:short)' refs/heads refs/remotes/origin`.
   - Session trajectory: review earlier turns of **this conversation** to identify
     files created, edited, or deleted during the session (and their original
     fix/feature intent).

2. **Four Sync Scopes & Smart Recommendation Priority (`四类合并范围与默认推荐序`)**:
   - **Scope 1 — Session Changes (`本次对话的改动`)**: Logical changes authored in
     the current conversation (uncommitted edits on session-touched files and/or
     commits created in this session), carrying full conversational context of
     *why* the change was made.
     - *Recommend first when*: files were modified earlier in this conversation.
   - **Scope 2 — Workspace Uncommitted Changes (`当前工作区未提交改动`)**: Staged,
     unstaged, and relevant untracked files in the active working tree *(or in the
     source branch's mounted worktree via `git -C <source_worktree>`)*.
     - *Recommend first when*: no files were edited in this conversation, and the
       working tree has uncommitted changes.
   - **Scope 3 — Source Branch Commits (`源分支领先提交: target..source`)**:
     Committed changes on `<source>` not yet reachable from `<target>`
     (`git log <target_ref>..<source_ref>`).
     - *Recommend first when*: the working tree is clean, or the user is already
       on `<target>` wanting to pull fixes from another `<source>` branch.
   - **Scope 4 — Specific Commits or File Paths (`指定 Commit / 文件路径`)**:
     Explicit commit SHA(s), range, or path subset supplied via prompt or `Other`.

3. **Gate 1 — Single-Turn On-Demand Parameter Collection (`单轮按需补全三要素`)**:
   Anchor three parameters: **Sync Scope (`合并范围`)**, **Source Branch (`源分支`)**,
   and **Target Branch (`目标分支`)**.
   - **Explicit fast-track (no redundant popup)**: if all three parameters are
     already clear and unambiguous from the user's prompt (e.g. *"把本次对话的改动从当前分支同步到 main"*),
     **skip Gate 1**, print a 1-line anchor summary
     (`📌 同步锚定：源 [<source>] → 目标 [<target>] | 范围 [<scope>]`), and proceed
     immediately to **Step 2**.
   - **Combined prompt for missing/ambiguous fields**: if any of the three is
     missing or ambiguous, adopt already-stated fields as fixed and ask **only**
     the remaining questions together in **one** structured prompt card:
     - **Sync Scope (`合并范围`)** — put the smart-detected scope first prefixed
       with `(Recommended)` and concrete file/commit counts (e.g.
       `(Recommended) 本次对话的改动（涉及 3 个文件）`,
       `当前工作区未提交改动（共 5 个变更文件）`,
       `源分支领先提交（target..source 已提交差异）`,
       `指定 Commit 或文件路径（请在 Other 中输入）`).
     - **Source Branch (`源分支`)** — default `(Recommended)` to `<current_branch>`
       when syncing Session or Workspace changes (or when currently on a
       non-trunk branch); if currently on the trunk branch with a clean tree,
       default `(Recommended)` to the most recently updated feature/fix branch,
       listing top recent branches below.
     - **Target Branch (`目标分支`)** — default `(Recommended)` to the detected
       primary integration branch (`main`, `master`, or `develop`—excluding
       `<source>`), followed by other active branches or mounted worktree branches.
   - *(Only run `git fetch origin <branch>` if a named branch ref does not exist
     locally at all, or if the user explicitly asks to fetch remote.)*

---

### Step 2: Zero-Checkout Semantic Extraction & 4-State Target Audit (`零切分支语义提炼与四类状态盘点`)

1. **Check Local `<target>` vs. Cached `origin/<target>` Freshness (`远端引用新鲜度离线核查`)**:
   - Without network blocking, check whether `origin/<target>` exists locally and
     compare `git rev-list --left-right --count <target>...origin/<target>`:
     - If local `<target>` is **behind** `origin/<target>` by `K > 0` commits (or
       only `origin/<target>` exists locally), perform the read-only semantic
       audit against the newer `origin/<target>` (`<audit_target_ref> = origin/<target>`)
       and flag the freshness gap prominently (`⚠️ 本地 <target> 落后于缓存的 origin/<target> 共 K 个提交；本次基于更新的 origin/<target> 盘点`).
     - Otherwise set `<audit_target_ref> = <target>`.

2. **Extract Source Changes & Group by True Semantic Intent (`提炼源改动真实语义单元`)**:
   - Read exact source diffs for the anchored `Sync Scope`:
     - *Session changes*: session-touched diffs plus the conversation's verbatim
       bug/feature goal.
     - *Workspace uncommitted*: `git diff HEAD`, `git diff --cached`, and new
       untracked files. **Cohesion guard**: if unrelated dirty files coexist in
       the workspace, separate them explicitly and note them as excluded candidates
       rather than silently mixing unrelated edits into the sync.
     - *Source branch commits*: inspect commit log (`git log --oneline <audit_target_ref>..<source_ref>`)
       and net merge-base diff (`git diff $(git merge-base <audit_target_ref> <source_ref>)..<source_ref>`),
       reading full surrounding functions so intermediate churn commits do not
       distort intent.
     - *Specific commits / paths*: `git show <sha>` or path-scoped diffs.
   - Partition source edits along functional boundaries into `M` cohesive
     **Logical Change Units (`逻辑变更单元`)** (never split mechanically per file).
     For each unit, distill:
     1. **True Intent & Root Cause (`真实语义与修复/改造目标`)** — *what* problem
        or requirement it addresses and *why*.
     2. **Behavioral Invariants (`核心契约不变量`)** — expected main flow, state
        transitions, side effects, and error handling.

3. **Inspect Target Architecture & Trace Moved/Refactored Code (`探查目标分支当前架构与事实源`)**:
   - Read `<audit_target_ref>` strictly read-only: use a clean mounted target
     worktree if `<audit_target_ref>` matches its checked-out HEAD, otherwise use
     `git show <audit_target_ref>:<path>`, `git ls-tree`, and
     `git grep <symbol> <audit_target_ref>`.
   - **Follow refactors instead of stopping at missing paths**: if a file, class,
     or function touched in `<source>` moved, split, or vanished on
     `<audit_target_ref>`, trace its new home via
     `git log -n 15 --stat --follow <audit_target_ref> -- <old_path>` and domain
     symbol search (`git grep <symbol> <audit_target_ref>`).
   - Check project conventions on `<audit_target_ref>` (`AGENTS.md`, `CLAUDE.md`,
     `GEMINI.md` if present), identify its **current SSOT** (schemas, DTOs,
     stores, shared components, error envelopes), and trace **3D call chains on
     `<audit_target_ref>`** (upstream callers, downstream dependencies/side
     effects, and lateral shared peers).

4. **Classify Each Logical Unit into 4 Semantic States (`四类状态精准归类`)**:
   - **`Already Synced (已同步)`**: Equivalent fix/feature already exists on
     `<audit_target_ref>` (cite exact target file + lines). → *No edit needed.*
   - **`Superseded by Refactor (已被后续重构覆盖)`**: `<audit_target_ref>`
     redesigned the flow so the root issue is genuinely resolved or obsolete.
     Verify all 5 invariants (main flow, data state, side effects, error
     handling, edge cases) against the new implementation and cite exact target
     lines; if any subtle regression or unhandled branch remains under the new
     architecture, split that gap into `Missing or Regressed`. → *No edit needed
     (when fully covered).*
   - **`Missing or Regressed — Needs Adaptation (仍缺失或存在回归，需重适配)`**:
     Absent, incomplete, or broken by later changes on `<audit_target_ref>`.
     Design the **minimal adaptation** written idiomatically against target's
     current architecture and SSOT. → *Add to Minimal Sync Plan.*
   - **`Semantic Conflict / Product Divergence (存在语义冲突或业务分歧，待拍板)`**:
     `<audit_target_ref>` deliberately altered business logic, contracts, or
     state rules in conflict with `<source>`. Prepare clear options with concrete
     trade-offs. → *Escalate in Gate 2.*

---

### Step 3: Present Audit & Minimal Sync Plan + Single-Step Merged Gate (`呈报最小改动清单与单步合并门禁`)

Output a structured report directly in the conversation (do not write report files
to disk unless asked):

1. **Sync Overview (`同步盘点总括`)** — `Source [<source>] → Target [<audit_target_ref>] | Scope [<scope>]`,
   counts across the 4 states (`已同步 X / 被重构覆盖 Y / 需重适配 Z / 分歧待拍板 W`),
   target freshness status (if local `<target>` lagged `origin/<target>`), and
   any unrelated dirty workspace files intentionally excluded.
2. **Four-State Semantic Audit Table (`四类状态对照盘点表`)**:

   | # | Logical Unit & True Intent | Semantic Status | Target Branch Evidence & Architectural Delta |
   |---|----------------------------|-----------------|----------------------------------------------|

3. **Minimal Sync Plan (`需同步的最小改动清单`)**:
   - **Clean early exit (`Z = 0` and `W = 0`)**: if every logical unit is proven
     `Already Synced` or `Superseded by Refactor`, state clearly that **zero code
     changes are required on `<target>`** and stop cleanly—do not open an
     execution gate.
   - Otherwise, for each item `#1..#Z` requiring adaptation, detail:
     - **Target Location (`目标落点`)**: target file(s), symbol(s), and line range.
     - **Target-Native Adaptation (`按目标架构重适配方案`)**: concise specification
       of what will be added/updated using target's current SSOT and abstractions
       *(explicitly noting why/where it differs from source code if refactored)*.
     - **Consistency & 3D Call-Chain Check (`五维一致性与调用链影响核查`)**:
       verified alignment of main flow, data state/SSOT, side effects, error
       semantics, and target-branch callers/shared peers (plus any companion test
       or type updates needed).

4. **Gate 2 — Single-Step Merged Execution Gate (`单步合并拍板门禁`)**:
   Consolidate **all** decisions needed to execute into **one** `ask_question`
   turn—never chain separate sequential confirmation popups:
   - **Decision 1 — Plan Approval (`改动清单拍板`)**:
     - `(Recommended) Approve & execute the Minimal Sync Plan (#1..#Z)`
       （`批准《最小改动清单》，立即执行同步适配`）
     - `Adjust specific items or scope first (type instructions in Other / chat)`
       （`调整清单或先讨论某几项（直接在输入框说明）`）
     - `Keep the audit & checklist only — do not modify code`
       （`仅保留盘点报告与最小改动清单，暂不修改代码`）
     - *(When local `<target>` lags cached `origin/<target>` or user may want a
       fresh network pull)* include an option or pair with freshness alignment
       (e.g. align `<target>` to `origin/<target>` / run `git fetch origin <target>`
       before applying, without overwriting unpushed local `<target>` commits).
   - **Decision 2 — Semantic Conflict Resolution *(include ONLY when `W > 0`)*
     (`业务/语义分歧拍板`)**:
     - Ask one concise multiple-choice question per `Semantic Conflict` unit,
       placing the `(Recommended)` architectural option first.
   - **Decision 3 — Target Workspace Landing Mode *(include ONLY when NOT already
     on `<target>` AND `<target>` is NOT already checked out in a clean mounted
     `git worktree`)* (`跨分支写入载体选择`)**:
     - **If the current workspace has uncommitted changes**:
       - `(Recommended) Create an isolated temporary git worktree for <target> (keeps current <source> workspace & uncommitted changes untouched)`
         （`新建独立临时 git worktree 写入目标分支（不动当前源分支与未提交现场）`）
       - `git stash current uncommitted changes, checkout <target>, and apply`
         （`先 git stash 暂存当前未提交改动，再切到目标分支 <target> 修改`）
       - `git stash current uncommitted changes, create new branch sync/<topic> from <target>, and apply`
         （`先 git stash 暂存，再基于目标分支新建 sync/<topic> 分支修改`）
     - **If the current workspace is clean**:
       - `(Recommended) Checkout <target> in current workspace and apply`
         （`直接切换到目标分支 <target> 修改`）
       - `Create an isolated temporary git worktree for <target> (keep current directory on <source>)`
         （`新建独立临时 git worktree 写入目标分支（当前目录保持在源分支）`）
       - `Create new branch sync/<topic> from <target> and apply`
         （`基于目标分支新建 sync/<topic> 分支修改`）

   *(If the user requests adjustments to the Minimal Sync Plan, revise the plan
   concisely and confirm once before editing files.)*

---

### Step 4: Safe Workspace Preparation, Minimal Adaptation & Verification (`安全落地、架构重适配与靶向验证`)

1. **Prepare the Approved Target Workspace Safely**:
   - **Current workspace already on `<target>`**: edit in place.
   - **Existing mounted `<target>` worktree**: edit inside that worktree path
     *(if that worktree already has unrelated dirty files, note them clearly and
     avoid touching them)*.
   - **Temporary isolated `git worktree`**: create a sibling worktree outside the
     current repo tree (e.g. `../<repo>-sync-<sanitized-target>` via
     `git worktree add <worktree_path> <target>`, or
     `git worktree add -b sync/<topic> <worktree_path> <base_ref>` if `<target>`
     is checked out elsewhere or a new branch was selected) so the source working
     tree remains completely clean.
   - **`git stash` + branch switch**: run
     `git stash push -u -m "code-sync: pre-sync backup from <source>"`, record the
     stash reference, verify a clean working tree, and switch to `<target>` (using
     `git merge --ff-only origin/<target>` only if fast-forward alignment was
     approved and local `<target>` has no diverging local commits) or
     `git checkout -b sync/<topic> <base_ref>`.

2. **Implement Minimal Target-Native Adaptations**:
   - Apply items `#1..#Z` strictly according to the approved Minimal Sync Plan
     and resolved conflict choices.
   - Write idiomatic target-branch code: use target's current SSOT models, shared
     utilities/components, imports, and error handling—**zero blind copy-paste of
     stale source helpers, zero leftover compatibility dead code, zero unrequested
     drive-by refactoring**.
   - Ensure cross-boundary companion files on `<target>` (types, schemas/DTOs,
     exports, configs, unit tests) are updated together so the end-to-end loop is
     closed.

3. **Run Fast Targeted Verification in the Target Workspace**:
   - Execute fast, side-effect-free checks scoped to touched modules in the target
     workspace/worktree (e.g. dry-run typecheck `tsc --noEmit`, targeted lint, or
     affected unit tests).
   - **Temporary worktree guard**: if a newly created temporary worktree lacks
     installed dependencies (e.g. missing `node_modules` or build cache), do
     **not** stall on unprompted heavy dependency installs—use workspace-resolvable
     checks when available or candidly mark runtime execution as
     `Not verified: temporary worktree lacks installed dependencies (run <command> to verify)`.
   - Never claim tests or builds pass without running them and observing real output.

---

### Step 5: Sync Sign-Off Table & Conditional Cleanup Handoff (`同步核销回执表与按需收尾闭环`)

1. **Present the Sync Sign-Off Table (`《同步核销回执表》`)**:
   - State the active **Target Workspace Path & Branch (`落地路径与分支`)**.
   - Output the sign-off table with clickable line-range links in the target
     workspace:

     | # | Logical Unit | Target Files & Line Links | Key Adaptation Applied | Verification Status |
     |---|--------------|---------------------------|------------------------|---------------------|

   - Summarize any **Unverified Items & Residual Risks (`未验证项与残留风险`)**
     candidly.

2. **Git Mutation Boundary & Conditional Cleanup Handoff**:
   - **Never run `git commit` or `git push` automatically.**
   - **Normal Landing (edited directly in the current workspace on `<target>` or
     in a pre-existing `<target>` worktree, with no temporary worktree and no
     `git stash` created by this skill)**:
     - **Stop cleanly without opening another prompt.** End with a single concise
       line noting that synced changes remain uncommitted for review, and the user
       may run `/agent-review` for an independent full-chain regression audit or
       `/work-report` for an item-by-item walkthrough.
   - **Isolated / Stashed Landing (this skill created a temporary `git worktree`
     OR stashed uncommitted work on `<source>`)**:
     - Explicitly report the temporary worktree path and/or `git stash` entry
       created.
     - Open **one** closing handoff gate:
       - `(Recommended) Keep synced changes uncommitted for manual inspection / /agent-review (keep temporary worktree / stash as-is)`
         （`保留未提交改动由我自行检视或运行 /agent-review（暂不提交，保留当前临时 worktree / stash）`）
       - *(When a temporary worktree was created)* `Commit synced changes on <target_branch> and clean up the temporary worktree`
         （`在目标分支 commit 本次同步改动，并自动移除临时 worktree`）
       - *(When git stash + branch switch was used)* `Commit synced changes on <target_branch>, switch back to <source>, and restore git stash`
         （`在目标分支 commit 本次同步改动，切回源分支 <source> 并 git stash pop 恢复现场`）
     - If the user approves the commit & cleanup/restore option: stage and commit
       **only** the synced files on `<target_branch>` with a clear commit message
       (never `git push` unless explicitly instructed), remove the temporary
       worktree (`git worktree remove <worktree_path>`) or checkout `<source>` and
       run `git stash pop`, and report the final `git status`.

---

## Anti-patterns

- Running `git cherry-pick`, `git merge`, or mechanical copy-paste of old source
  code onto a refactored target branch, overwriting newer target abstractions or
  reintroducing old structures.
- Concluding a change is `"already handled"` or `"no longer needed"` just because
  the source file path disappeared on `<target>`, without tracing `git log --follow`
  / `git grep` to verify the refactored implementation actually covers the bug.
- Switching branches or running `git stash` during the **analysis phase** before
  presenting the Minimal Sync Plan and getting user approval.
- Bundling unrelated dirty files from `git status` into the sync plan without
  flagging and separating them.
- Chaining multiple consecutive confirmation popups instead of merging missing
  parameters (Gate 1) and plan/conflict/landing choices (Gate 2) into single-turn
  structured gates.
- Fabricating `"tests pass"` without real command output on the target workspace,
  or running `git commit` / `git push` without explicit user approval.
