---
name: code-sync
description: >-
  Interactive, intent-driven cross-branch code synchronization and semantic porting
  workflow with strict parallel-session isolation, Result-First outcome reporting,
  Smart Fast-Path execution, and automatic post-merge agent-review. Locks strictly
  to the requested scope (e.g. current session changes only) without analyzing
  unrelated commits or parallel tasks unless directly conflicting, audits target
  state read-only, re-adapts idiomatically to target SSOT, verifies, and triggers
  an isolated Result-First agent-review on the merged changes.
  Triggers: /code-sync, "code sync", "sync to branch", "port changes to",
  "semantic merge", "merge to branch", "sync code", "代码同步", "代码合并",
  "同步到分支", "合并到分支", "把改动同步到", "同步代码", "向目标分支同步".
license: MIT
compatibility: >-
  Works best with a structured question tool (e.g. ask_question, AskUserQuestion),
  subagent delegation for post-merge agent-review, Git shell, and file read/edit
  tools; falls back gracefully when structured prompts or subagents are unavailable.
metadata:
  author: Ainward
  version: "1.1.0"
  status: experimental
  category: "code-sync, semantic-merge, branch-porting, software-engineering"
  verified-agents: "antigravity"
---

# Code Sync (语义化代码同步与跨分支合并)

Synchronize bug fixes, features, or refactors from a source context to a target
branch **by true engineering intent rather than mechanical patch replay**—while
enforcing **strict parallel-conversation isolation**, **Smart Fast-Path execution
when conflict-free**, **Result-First reporting** (hiding noisy line numbers and
class dumps by default), and **automatic post-merge `agent-review`**.

## When to use

- Porting or syncing changes made in the **current conversation**, **dirty working
  tree**, **diverged feature/hotfix/release branch**, or **specific commits/files**
  into another branch (such as `main`, `develop`, or a release branch), especially
  when parallel tasks or conversations also touch the repository.
- Synchronizing fixes across branches that have undergone structural refactoring,
  file moves, or Single Source of Truth (SSOT) changes where raw `git merge` or
  `git cherry-pick` would conflict or introduce silent semantic regressions.

Do **not** use this skill as a mechanical `git merge` wrapper when the user
explicitly asks to run a raw `git merge --ff-only` or branch topology operation
without code inspection.

## Core principles

1. **Semantic intent & target architecture over mechanical copying (`语义与目标架构优先`).**
   **Never** blindly `git cherry-pick`, `git apply`, or copy-paste legacy hunks
   verbatim onto the target branch. Extract the root problem and behavioral
   contract of each source change first, then adapt it idiomatically to the
   target branch's **current module boundaries, shared abstractions, and SSOT**.

2. **Strict bidirectional parallel isolation (`双向并行隔离与严格遵循指令范围`).**
   - **Source-side hard lock (`源端严格硬锁定`)**: When the user asks to sync
     **this conversation's changes (`本次对话的改动`)** or specifies explicit
     commits/files, treat that scope as a **strict allowlist**. Extract **only**
     files, logical hunks, and commits actually authored in **this conversation**
     (from session trajectory). **Never** run `git log <target>..<source>`, never
     analyze other parallel conversations' commits on the same branch, and never
     pull in unrelated dirty workspace files—silently exclude them without
     analyzing or listing them. If zero edits/commits occurred in this
     conversation when Session Changes was requested, pause and ask instead of
     silently falling back to branch commits or `git diff`.
   - **Target-side snapshot isolation (`目标端只读最新快照，绝不泛扫并行提交`)**:
     Inspect **only** the **current latest snapshot** on `<audit_target_ref>`
     for files, callers, and shared contracts directly relevant to the locked
     source units. **Strictly forbid** scanning `git log` of unrelated parallel
     commits on `<target>` (e.g., other tasks concurrently pushing to `main`).
     Trace a target commit **only** when a direct line-level conflict, same-file
     dirty conflict, or contract breakage occurs with the current sync units—and
     **never** touch, stage, revert, or `stash` unrelated dirty files on `<target>`.

3. **Internal code rigor, external Result-First minimalism (`内严外简：内部严查、外部说人话`).**
   Internally execute the full 4-state semantic audit (`Already Synced`,
   `Superseded by Refactor`, `Missing or Regressed`, `Semantic Conflict`) plus
   5-dimension consistency & 3D call-chain verification on `<target>`:
   - **Main Execution Flow**, **Data State & SSOT**, **Side Effects**, **Error &
     Failure Semantics (anti-silent-fallback)**, and **3D Call-Chain Safety on Target**.
   Externally by default, translate findings into **plain functional language**
   and include **short target filenames** (e.g. `orderService.ts`) so the
   developer knows exactly which files changed—while **hiding `#L` line numbers,
   class/method/symbol dumps, and heavy audit jargon**. Present crisp outcomes
   (`同步了什么能力 / 涉及文件 / 哪些已覆盖跳过 / 验证结果 / 独立审查结论 / 有无冲突`),
   and surface line-level details when a conflict requires decision or when the
   user asks to expand (`展开细节` / `show details`).

4. **Smart Fast-Path & single-step conflict/closing gates (`无冲突直奔结果，有事单步拍板`).**
   - Skip Gate 1 whenever Source, Target, and Scope are already clear.
   - **Smart Fast-Path (skip Gate 2)**: when parameters are anchored,
     `Semantic Conflict (W) = 0`, target files to modify have no conflicting
     parallel dirty edits, local `<target>` does not lag `origin/<target>`, and
     landing can proceed safely without `git stash` or disrupting `<source>`,
     **skip the pre-execution checklist popup** and execute adaptation, targeted
     verification, and post-merge `agent-review` straight through to the final
     unified Result Summary.
   - Pause **only** when human judgment is genuinely required (`W > 0`, same-file
     dirty conflict on `<target>`, local `<target>` lagging `origin/<target>`, or
     unavoidable workspace choice). Merge all needed decisions into **one** gate.

5. **Automatic post-merge `agent-review` & safe closing lifecycle (`合并后自动独立审查与零打扰收尾`).**
   - Whenever code was actually written to `<target>` (`Z > 0`), automatically
     chain into **`agent-review`** (unless the user explicitly requested skipping
     review) using an isolated **Target-Merge Dispatch Packet** (`Target Workspace`,
     `Locked Change Scope`, verbatim requirement, `Output Profile: Result-First (Chained)`)—**never**
     passing `code-sync`'s self-justifications or `"tests pass"` claims.
   - Never run `git commit` or `git push` automatically. If review returns
     `Pass` and no temporary `worktree`/`stash` was created, stop cleanly with
     **zero** closing popups; otherwise open at most **one** closing gate.

6. **Reply in the user's language.**

## Host adaptation

- **Question gate:** if the host provides a structured question tool (e.g.
  `ask_question` in Antigravity, `AskUserQuestion` in Claude Code), use it—grouping
  any simultaneous choices into a single multi-question card so the user submits
  once. Otherwise, present concise numbered options in plain text. Either way,
  **end your turn immediately after asking.**
- **Code references:** show **short target filenames** in default `Result-First`
  summaries, while **omitting `#L` line numbers and class/symbol dumps**.
  Retain exact target file paths, line ranges, and 3D references in working
  memory so you can output clickable links
  (`[order.ts](file:///abs/path/order.ts#L42-L58)` or `<target_ref>:path#L42-L58`)
  immediately if a conflict requires disambiguation or the user asks `"展开细节"`.

---

## Workflow

### Step 1: Fast Read-Only Sensing & Strict Scope Locking (`静默预检与范围硬锁定`)

1. **Run fast local Git sensing (read-only; never run `git fetch` automatically)**:
   - Current branch & HEAD: `git branch --show-current` and `git rev-parse --short HEAD`.
   - Working tree status: `git status --porcelain=v1 -b`.
   - Mounted worktrees: `git worktree list` *(check where `<target>` or `<source>` is already checked out)*.
   - **Conditional branch list**: run `git for-each-ref --sort=-committerdate --format='%(refname:short) %(objectname:short) %(upstream:short)' refs/heads refs/remotes/origin`
     **only** when Source or Target branch is unspecified/ambiguous.
   - **Session Trajectory Audit**: inspect earlier turns of **this conversation**
     to assemble the **strict session allowlist**:
     - Exact file paths created, edited, or deleted in this conversation;
     - Specific commit SHA(s) explicitly created during this conversation (if
       changes were already committed in this session);
     - Specific logical hunks/intent authored here (in case a shared file also
       contains concurrent uncommitted edits from another parallel session).

2. **Four Sync Scopes & Hard Lock Rules**:
   - **Scope 1 — Session Changes (`本次对话的改动`)** *(Strict Allowlist)*:
     - Includes **only** uncommitted edits authored in this conversation and/or
       commit SHA(s) explicitly created in this conversation.
     - **Zero-Edit Guard**: if the user explicitly requested *"本次对话的改动"*
       (or *"本轮对话涉及变更的代码"*) and **zero** files/commits were authored
       in this conversation, **stop at Gate 1**—state clearly that no code edits
       were created in this session, and ask them to pick Workspace Uncommitted
       Changes, Source Branch Commits, or Specific Commits/Paths. **Never**
       silently fall back to `git diff` or `target..source` commits.
     - **Silent Parallel Exclusion**: other commits on the source branch and
       other dirty workspace files are strictly out of scope—do **not** inspect,
       analyze, or list them.
   - **Scope 2 — Workspace Uncommitted Changes (`当前工作区未提交改动`)**:
     - Staged, unstaged, and untracked changes in the active working tree.
       **Cohesion guard**: if unrelated dirty files from other parallel tasks
       coexist, exclude them unless explicitly included.
   - **Scope 3 — Source Branch Commits (`源分支领先提交: target..source`)**:
     - Used **only** when explicitly requested by the user or selected in Gate 1.
       Never substitute Scope 3 for Scope 1.
   - **Scope 4 — Specific Commits or File Paths (`指定 Commit / 文件路径`)**:
     - Strict allowlist of only the named SHAs, ranges, or file paths.

3. **Gate 1 — Single-Turn On-Demand Parameter Anchoring (`单轮按需补全三要素`)**:
   Anchor **Sync Scope**, **Source Branch**, and **Target Branch**.
   - **Explicit fast-track (skip Gate 1)**: when all three are unambiguous from
     the user's prompt (e.g. *"把本轮对话涉及变更的代码合并到 main"*), **skip
     Gate 1**, output a 1-line anchor
     (`📌 同步锚定：<source> → <target> | 范围：<scope>`), and proceed
     directly to **Step 2**. *(Note: if the user asks for Session Changes on a
     zero-edit session, the Zero-Edit Guard overrides and opens Gate 1.)*
   - **Combined prompt for missing/ambiguous fields**: ask **only** missing or
     ambiguous items together in **one** structured prompt card with
     `(Recommended)` defaults (putting `本次对话的改动` first when session edits
     exist, followed by uncommitted workspace changes, branch commits, or
     explicit paths/SHAs).
   - *(Only run `git fetch origin <branch>` if a named branch does not exist
     locally at all or the user explicitly requests a network fetch.)*

---

### Step 2: Zero-Checkout Target Snapshot Inspection & Internal 4-State Audit (`零切分支目标快照核查与内部四态审计`)

1. **Offline Freshness Check (`<target>` vs. cached `origin/<target>`)**:
   - Check `git rev-list --left-right --count <target>...origin/<target>` if
     `origin/<target>` exists locally (do **not** run `git log` on those commits).
   - If local `<target>` is **behind** `origin/<target>` by `K > 0` commits (or
     only `origin/<target>` exists locally), set `<audit_target_ref> = origin/<target>`
     and mark `needs_freshness_alignment = true` (with lag count `K`).
   - Otherwise set `<audit_target_ref> = <target>` and `needs_freshness_alignment = false`.

2. **Extract ONLY Locked Source Changes**:
   - **Scope 1 (`Session Changes`)**:
     - If uncommitted: inspect **only** the session-touched files (`git diff HEAD -- <session_files>`
       plus new session files). If another parallel session concurrently
       modified unrelated lines inside the same file, isolate **only** the
       logical hunks authored in this conversation.
     - If committed in this session: inspect **only** `git show <session_commit_sha>`
       (never `target..source`!).
   - **Scopes 2 / 3 / 4**: inspect strictly within their locked boundary.
   - Partition into `M` cohesive **Logical Change Units (`逻辑变更单元`)**,
     capturing each unit's **plain functional/business goal** and **behavioral
     invariants** (expected flow, state transitions, side effects, error handling).

3. **Target Snapshot Inspection & Strict Target Isolation (`只读最新快照，严禁泛扫并行历史`)**:
   - Inspect `<audit_target_ref>` **strictly read-only** and **strictly scoped**
     to files, modules, and direct 3D callers/callees/shared peers relevant to
     the `M` units:
     - Use clean mounted target worktree files when `<audit_target_ref>` matches
       its HEAD, otherwise `git show <audit_target_ref>:<path>` and
       `git grep <symbol> <audit_target_ref>`.
   - **Target Isolation Rule**: **NEVER** run `git log` to browse, analyze, or
     summarize unrelated parallel commits on `<target>`.
     - *Exception 1 — Refactored/moved file lookup*: ONLY if a source-touched
       file path vanished on `<audit_target_ref>`, locate its new home via
       `git grep <symbol> <audit_target_ref>` or narrow
       `git log -n 10 --follow --stat <audit_target_ref> -- <old_path>` (without
       analyzing other unrelated changes in those commits).
     - *Exception 2 — Conflict-only attribution*: ONLY when an active unit hits
       a direct line-level conflict, same-file dirty conflict, or contract/caller
       breakage on `<audit_target_ref>`, inspect the specific overlapping commit
       (`git log -n 3 <audit_target_ref> -- <conflicting_path>`) so conflict
       options reflect accurate context.
   - **Target Dirty-File Check**: if `<target>` is currently checked out in the
     active workspace or a mounted sibling worktree, check `git -C <target_path> status --porcelain=v1`
     **solely** to see if any file slated for modification (`Z > 0`) has
     uncommitted parallel edits (`target_dirty_conflict = true`). Ignore all
     unrelated dirty files completely.

4. **Internal 4-State Classification & 5-Dimension Safety Check**:
   Classify each of the `M` units **internally** (keeping exact file/line/3D
   notes in working memory without dumping them verbatim by default):
   - **`Already Synced (已同步)`**: equivalent behavior already exists on
     `<audit_target_ref>`. → *Skip.*
   - **`Superseded by Refactor (已被后续重构覆盖)`**: `<audit_target_ref>`
     redesigned the module and eliminated the root cause across all 5
     invariants (main flow, data state, side effects, error handling, edge cases).
     Split any remaining gap into `Missing or Regressed`. → *Skip when covered.*
   - **`Missing or Regressed — Needs Adaptation (仍缺失或需重适配)`**: absent,
     incomplete, or broken on `<audit_target_ref>`. Design minimal adaptation
     idiomatically aligned with target's current SSOT, shared helpers, and 3D
     call chains (plus companion types/configs/tests). → *Count into `Z`.*
   - **`Semantic Conflict / Product Divergence (存在冲突或分歧)`**: target
     altered contracts/rules in direct conflict with the change, or has a
     concurrent edit collision. Prepare crisp options. → *Count into `W`.*

---

### Step 3: Smart Routing — Early Exit, Fast-Path Execution, or Conflict Gate (`智能分流：零改动退出 / 无冲突直通 / 单步拍板`)

Evaluate the exact state counts `(Z, W)` and safety flags:

1. **Branch A — Clean Early Exit (`Z = 0` and `W = 0`)**:
   - Zero edits required on `<target>`. Do **not** pause and do **not** run
     `agent-review` (nothing was modified on target).
   - Output a **Result-First Summary** in plain functional language:
     - **总结论**：目标分支 `<target>` 无需修改（本轮 `M` 项改动已全部存在或已被目标分支最新方案覆盖）。
     - **逐项结果**：1 行/项说明「改动能力 → 跳过原因（已同步 / 已被新架构覆盖）」（**无 `#L` 行号、无类名堆砌**）。
     - **按需展开提示**：`如需查看具体对比文件或代码行号，回复“展开细节”即可。`

2. **Branch B — Smart Fast-Path (`无冲突直奔结果`)**:
   Trigger **automatically** when **ALL** of the following hold:
   - `Z > 0` (adaptations needed on `<target>`),
   - `W = 0` (zero semantic conflicts / product divergence),
   - `target_dirty_conflict == false` (no parallel dirty edits on the exact
     target files to modify),
   - `needs_freshness_alignment == false` (local `<target>` is not lagging
     cached `origin/<target>`), and
   - Safe isolated landing is available without `git stash` or switching a dirty
     source branch (i.e., already on `<target>`, `<target>` is in a mounted
     worktree, or `<target>` is unmounted so a temporary isolated `git worktree`
     can be created silently without disturbing `<source>`).
   - **Action**: **Do NOT output a pre-execution audit table and do NOT open
     Gate 2.** Proceed immediately to **Step 4** and **Step 5**, delivering one
     unified Result Summary at the end!

3. **Branch C — Single-Step Conflict / Alignment Gate (Pause ONLY when needed)**:
   Trigger when **ANY** of `W > 0`, `target_dirty_conflict == true`,
   `needs_freshness_alignment == true`, or unsafe/ambiguous landing holds.
   - **Output concisely (Result-First!)**:
     - State in 3–5 plain-language lines: how many units will auto-sync/skip, and
       **only the exact blocking conflict / dirty clash / freshness lag** in
       business terms *(include at most short filenames only if needed to
       disambiguate the conflict—still no `#L` line dumps or 5-dimension essays)*.
   - **Open ONE merged `ask_question` turn** containing only the required
     decisions:
     - *(When `needs_freshness_alignment`)* Align local `<target>` to
       `origin/<target>` (`K` commits behind) before applying vs. sync against
       local `<target>` as-is;
     - *(When `W > 0`)* One multiple-choice question per conflict unit with the
       `(Recommended)` option first;
     - *(When `target_dirty_conflict`)* Isolate onto a new `sync/<topic>`
       worktree vs. adapt alongside current target dirty edits vs. hold;
     - *(When landing requires a user choice, e.g. `stash + checkout`)* Landing
       mode (`isolated worktree` recommended over `git stash`).

---

### Step 4: Safe Isolated Adaptation & Fast Targeted Verification (`安全隔离落盘与靶向验证`)

1. **Prepare Target Workspace Safely (Zero Disruption to Parallel Tasks)**:
   - **Current workspace already on `<target>`**: edit **only** the synced target
     files in place. Never touch, `git add`, `git checkout --`, or `git stash`
     unrelated dirty files.
   - **Existing mounted `<target>` worktree**: edit **only** the synced target
     files inside `<target_worktree_path>` (never touching unrelated dirty files
     in that worktree).
   - **Temporary isolated `git worktree`** *(automatic cross-branch carrier when
     `<target>` is not checked out elsewhere, or `-b sync/<topic>` when chosen)*:
     create a sibling directory outside the repo tree
     (`../<repo>-sync-<sanitized-target>` via `git worktree add <path> <target>`
     or `git worktree add -b sync/<topic> <path> <base_ref>`), leaving `<source>`
     100% untouched. Record `created_temp_worktree = true`.
   - **Approved `git stash` + branch switch**: execute **only** when explicitly
     chosen by the user in Gate 2. Record `created_temp_stash = true`.

2. **Implement Minimal Target-Native Adaptations**:
   - Write idiomatic target-branch code aligned with `<target>`'s current SSOT,
     shared components, and error envelopes—zero blind copy-paste, zero drive-by
     refactoring, zero leftover dead shims.
   - Update required companion files on `<target>` (types, schemas, configs,
     unit tests) so the end-to-end loop is closed.
   - Record the exact list of **Synced Target Files & Diffs** created in this
     step (`synced_target_files`) as the locked handoff boundary for Step 5.

3. **Run Fast Targeted Verification in `<target_workspace_path>`**:
   - Run side-effect-free targeted checks scoped to the synced modules inside
     `<target_workspace_path>` (e.g. typecheck, lint, affected unit tests).
   - **Temporary worktree guard**: if a newly created temporary worktree lacks
     installed dependencies (e.g. missing `node_modules` / `.venv`), do **not**
     run heavy installs unprompted; mark execution candidly as `Not verified`
     and capture the exact targeted command the user can run once back on
     `<target>` (e.g. `pnpm test orderService`).
   - Never fabricate passing checks without real observed output.

---

### Step 5: Automatic Post-Merge `agent-review`, Result-First Delivery & Closing Gate (`合并后独立审查、结果直出与收尾闭环`)

1. **Automatically Invoke `agent-review` (unless explicitly skipped by user)**:
   If `agent-review` is available (via its `Part 1` subagent protocol; otherwise
   use its `Single-Session Fallback`), build a **Contamination-Free Target-Merge
   Dispatch Packet**:
   - **Scope & Focus**:
     `Locked Change Scope: [<exact synced_target_files and target diff/hunks>]`
     *(explicitly instructing the reviewer: inspect ONLY these synced target
     changes inside `<Target Workspace>`; do NOT audit source-branch edits,
     unrelated dirty files, or parallel commits on `<target>`—expand 3D only
     along callers, callees, and shared peers interacting with these synced
     changes)*.
   - **Target Workspace**: `<target_workspace_path>` *(CRITICAL: pass the exact
     worktree/directory path where Step 4 wrote changes, leaving subagent
     `Workspace` at `"inherit"` so it can access sibling worktree paths via
     `read_file` and `git -C <target_workspace_path>`)*.
   - **Mode**: `Change Review`
   - **Original Requirement Context**: **Verbatim ONLY** — quote only the user's
     original goal/prompt for the changes being synced. **Strictly forbidden**:
     never pass `code-sync`'s internal audit, SSOT justifications, or *"tests pass"*
     claims.
   - **Output Language**: user's language.
   - **Output Profile**: `Result-First (Chained)` *(instructs `agent-review` to
     execute full internal 3D verification while outputting **Template C2**
     without `#L` line links or class/symbol dumps, caching details for
     `"展开细节"`)*.

2. **Deliver One Unified Result-First Report (`合并与审查最终结果`)**:
   Merge sync outcome, targeted verification, and the `agent-review` findings
   into **one** scannable response in **plain developer language**—including
   **short target filenames** for transparency, while keeping **zero `#L` line
   numbers, zero class/symbol dumps, and zero heavy audit jargon**:
   - **1. 总结论（1–2 句）**：说明已同步到目标分支 `<target>`（若落在独立临时
     worktree 则附路径）、`已适配 X 项 / 覆盖跳过 Y 项`、靶向验证状态，以及
     `agent-review` 审查结论（`Pass` / `Pass with Risks` / `Changes Requested`）。
     *(If checks were skipped because a temporary worktree lacked dependencies,
     state in 1 plain sentence why tests could not run inside that temporary
     directory and include the exact command to run after switching to
     `<target>`.)*
   - **2. 同步结果清单（功能效果 + 短文件名）**：

     | # | 改动内容（功能效果） | 涉及文件 | 处理结果 | 验证状态 |
     |---|----------------------|----------|----------|----------|

     *(Use plain outcomes like `已同步适配` / `已覆盖跳过` / `已按拍板解决`,
     short filenames like `orderService.ts`, and honest check status like
     `单测通过` / `未跑单测（临时目录无依赖）`.)*
   - **3. 独立审查结果（`agent-review`）**：
     Relay the subagent's `Result-First (Chained)` report intact without
     softening verdicts or dropping `P0`/`P1`/`P2` findings or `Not verified`
     blind spots:
     - When clean: `Pass — 独立子 Agent 已核查本次合并的上下游调用与公共复用，未发现 P0/P1/P2 问题。`
     - When issues or blind spots exist: list confirmed `[P0/P1/P2]` risks,
       functional impact/trigger, and fix direction (in plain developer language).
   - **4. 按需展开提示（1 行）**：
     `如需查看完整路径、代码行号或完整调用链细节，回复“展开细节”即可。`

3. **Conditional Single Closing Gate (Zero Popup When Clean!)**:
   - **Never run `git commit` or `git push` automatically.**
   - **Clean Finish (`Pass` / zero `P0` & `P1` blockers AND `created_temp_worktree == false` AND `created_temp_stash == false`)**:
     - **Stop cleanly with ZERO modal popups.** Note in one brief line that
       changes remain uncommitted on `<target>` for final check.
   - **Needs Follow-up (`P0`/`P1` found by `agent-review` AND/OR `created_temp_worktree == true` OR `created_temp_stash == true`)**:
     - Consolidate all remaining actions into **at most ONE** `ask_question` card:
       - *(Include when `P0`/`P1` found)* `(Recommended) Fix P0/P1 findings on <target> and re-verify`
         （`按审查建议修复 P0/P1 风险并复核`）
       - *(Include when `created_temp_worktree` or `created_temp_stash`)*
         - *(Prefix with `(Recommended)` when NO `P0`/`P1` blockers exist!)*
           `Commit synced changes on <target_branch> and clean up temporary worktree`
           （`在目标分支 commit 本次同步改动，并自动清理临时 worktree`） *(or switch back to `<source>` & `git stash pop`)*
         - `Keep synced changes uncommitted for manual inspection (keep temporary worktree/stash)`
           （`保留未提交改动与临时 worktree，由我自行检视`）
       - *(Include when `P0`/`P1` found and NO temp worktree/stash)*
         - `Keep current changes as-is — I will handle them manually`
           （`保留现状，交由我自行处理`）
     - **If user chooses to fix `P0`/`P1`**: apply targeted fixes strictly inside
       `<target_workspace_path>`, re-verify, and re-run `agent-review` on the
       locked scope (then offer commit/cleanup only if a temp worktree/stash
       remains).
     - **If user chooses commit & cleanup/restore**: stage and commit **only**
       `synced_target_files` (never unrelated parallel dirty files!) with a clear
       commit message, remove temporary worktree (`git worktree remove <path>`)
       or restore source branch + `git stash pop`, and report final status.

4. **On-Demand Technical Expansion (`按需展开细节`)**:
   If the user replies `"展开细节"` / `"看具体代码行"` / `"show details"`,
   immediately surface the retained technical evidence from this run: clickable
   file + line-range links, adapted symbol names, SSOT mapping deltas, and full
   3D call-chain findings.

---

## Anti-patterns

- Pulling `git log <target>..<source>` commits or unrelated workspace dirty files
  into a **Session Changes** sync, or silently falling back to branch commits
  when zero edits were authored in the current conversation.
- Scanning `git log` of unrelated parallel commits on `<target>` (e.g. `main`)
  when no direct conflict exists, or touching/stashing unrelated dirty files on
  `<target>`.
- Dumping `#L` line numbers, class/symbol inventories, or 5-dimension technical
  walls in default outputs instead of delivering concise Result-First outcomes.
- Running `git cherry-pick`, `git merge`, or mechanical copy-paste onto a
  refactored target branch, or running `git stash` / `git checkout` unprompted
  over active parallel work.
- Skipping post-merge `agent-review` after modifying `<target>` (unless asked),
  passing `code-sync`'s self-summary or `"tests pass"` claims into the reviewer,
  or pointing the reviewer at the parent workspace when changes landed in a
  sibling `git worktree`.
- Fabricating `"tests pass"` without observed output, or running `git commit` /
  `git push` without explicit user approval.
