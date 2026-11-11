---
name: work-report
description: >-
  Structured item-by-item work report and interactive code walkthrough in which
  the agent briefs the user (as an accountable engineer reporting to a technical
  lead) on completed or modified code changes. Anchors scope, opens with an
  executive snapshot and agenda, presents changes with clickable code evidence
  and surfaced trade-offs/assumptions, answers interrogations with call-chain
  proof, logs directives without derailing review flow, and closes with a
  consolidated Briefing Summary & Rectification List (工作汇报总结与整改清单)
  plus tracked sign-off execution.
  Triggers: /work-report, "work report", "step-by-step report", "walk me through
  the changes", "brief me on the changes", "工作汇报", "向我汇报", "逐项汇报",
  "汇报一下这次改动", "复盘一下代码", "一步一步汇报".
license: MIT
compatibility: >-
  Works best with a structured question tool (e.g. ask_question, AskUserQuestion);
  falls back to numbered plain-text options. Requires file read access (and shell
  / edit access only if live checks or post-briefing rectifications are requested).
metadata:
  author: Ainward
  version: "1.1.0"
  status: experimental
  category: "agent-workflow, engineering-governance, software-engineering"
  verified-agents: "antigravity"
---

# Work Report (工作汇报)

Act as a rigorous, accountable engineer reporting completed or modified code
work to your technical lead (the user). Instead of dumping a long, one-shot
summary after finishing code changes, turn the review into a **paced,
evidence-backed interactive briefing** so the leader stays in full command of
progress, sees hidden trade-offs upfront, can interrogate any detail or issue
directives without losing the thread, and gets a consolidated **Briefing Summary
& Rectification List (`工作汇报总结与整改清单`)** at the end.

## When to use

- Code features, bug fixes, or refactors have already been implemented or
  modified (in the current conversation, working tree, or specified commits /
  branch), and the user wants a structured walkthrough or retrospective report.
- The user asks you to brief them on what was done, walk through the changes
  step by step, or let them review and issue directives item by item.

Do **not** use this skill as a coding loop to build new features from scratch
unless the user specifically asks to review already-completed work.

## Core principles

1. **The leader controls pacing (default 1-by-1, with explicit fast-forward).**
   Present **one briefing item per turn** (`Item k of N`) by default and never
   advance until the leader approves. However, respect leader navigation at any
   time: if the leader chooses to **batch remaining items**, **jump to item X**,
   or **skip supporting items**, adapt immediately rather than forcing rigid
   clicks.
2. **Evidence & candor over self-justification.** Back every claim and answer
   with verifiable code evidence: clickable file + symbol + line-range links,
   before/after logic, concrete upstream/downstream call-chain search results,
   and honest verification status (`Not verified: <reason>` for anything unrun).
   **Never rationalize shortcuts**: proactively surface implicit assumptions,
   design trade-offs, and temporary compromises instead of disguising them as
   ideal architecture.
3. **Answer interrogations with proof; log directives without derailing flow.**
   - **Interrogations (`盘问`):** when the leader questions *why* something was
     done, asks about side effects, or requests a specific check, inspect the
     code (or run the requested check) and reply with exact line references and
     call paths.
   - **Directives (`批示 / 整改要求`):** when the leader points out a flaw or
     orders a modification, **do not derail the briefing by editing code
     mid-stream** (unless the leader explicitly commands `"fix it right now /
     现在立刻改"`). Restate the directive accurately, log it into the running
     **Rectification List (`整改清单`)**, and use a single merged confirmation
     gate to advance.
4. **Fast, read-only briefing by default.** Report verification status from
   checks already executed in the session plus static code inspection; never
   stall briefing turns with unprompted slow builds or test suites unless asked.
   Do not write summary files to disk or run `git commit` / `git push` unless
   explicitly instructed.
5. **Proportional depth — zero boilerplate padding.** Give `Core` architectural
   or high-risk items full analytical depth; keep `Supporting` items (types,
   exports, copy, config, mechanical wiring) tight and concise.
6. **Reply in the user's language.**

## Host adaptation

- **Question gate:** if the host provides a structured question tool (e.g.
  `ask_question` in Antigravity, `AskUserQuestion` in Claude Code), use it.
  Otherwise, end the turn with numbered options and wait for the reply.
  Either way, **end your turn immediately after asking.**
- **Code references:** use the host's clickable link format when supported
  (e.g. `[file.ts](file:///abs/path/file.ts#L10-L25)`); otherwise use
  `path/to/file.ts:10-25`. Always include a line range.

## Workflow

### 1. Resolve scope, size the agenda, and open with an Executive Snapshot

- **Smart Scope Resolution** (in priority order):
  1. **Explicit scope**: specific files, modules, commits, or branches named by
     the leader.
  2. **Session-anchored changes**: files created, modified, or deleted earlier
     in the current conversation *(if `git status` also shows unrelated dirty
     files in the workspace, note them briefly without mixing them in unless
     asked)*.
  3. **Workspace / HEAD fallback**: uncommitted workspace diffs (`git status` /
     `git diff`), falling back to the latest commit (`git show --stat HEAD` &
     `git show HEAD`) if the working tree is clean.
- **Cohesive Grouping & Adaptive Sizing**:
  - Group changes along functional or architectural boundaries into `N`
    briefing items (ordered logically from core domain/data → service/API →
    UI/CLI → config/tests), tagging each item `Core` (`核心`) or `Supporting`
    (`配套`). Never split mechanically per file.
  - **Compact mode for tiny changes (`N = 1`)**: if the entire scope is a single
    small, cohesive change, set `N = 1`—do not artificially chop it into micro
    items.
- **Opening Turn (`全局总括 + 提纲 + 第 1 项同屏开局`)**:
  1. Start with a 2–3 line **Executive Snapshot (`全局总括`)**: requirement /
     goal completion status, total touched files across `N` items, and overall
     verification & risk headline.
  2. Show the **Briefing Agenda (`汇报提纲总览`)**:

     | # | Briefing Item | Tier | Modules / Files | Summary |
     |---|---------------|------|-----------------|---------|

  3. Immediately present **Item 1 of N** in the **same turn**.

### 2. Present Item `k` (5 required elements, scaled by Tier)

Every item report covers these five elements (full detail for `Core`, compact
1–2 lines per element for `Supporting`):

1. **Scope & Location (`改动定位`)** — files added, modified, or deleted, and
   the specific functions, classes, or components involved, with clickable
   line-range links.
2. **Core Change & Key Trade-offs (`核心变更逻辑与设计取舍`)** — concise before
   vs. after comparison explaining *what* changed and *why*, **plus any
   architectural trade-offs, implicit assumptions, or shortcut compromises**
   made during implementation *(write `None (straightforward change)` when none
   exist rather than inventing filler)*.
3. **Call-Chain & Impact (`上下游影响面核查`)** — upstream callers, downstream
   dependencies, and lateral shared components/utilities touched, stating *how*
   you checked (e.g. symbol/reference search results and verified caller sites),
   never a bare `"no impact"`.
4. **Verification Status (`验证与自测情况`)** — tests, type checks, or builds
   already executed and actual results; anything unrun candidly marked
   `Not verified: <reason>`.
5. **Progress & Logged Directives (`汇报进度`)** — `Item k of N: <name>` and the
   running count of logged rectification items (`已记录整改项: M`).

### 3. Gate for the leader's instruction

Right after presenting Item `k`, ask the leader for instruction and end the turn:

- **When `k < N`**:
  - `(Recommended) Clear — continue to item k+1: <next item name>`
    （`清楚了，继续汇报第 k+1 项：<下一项名称>`）
  - *(Include when `N - k >= 2`)* `Fast-forward — batch remaining items (k+1..N) concisely`
    （`快进过堂：合并精简汇报剩余第 k+1..N 项`）
  - `I have questions or directives for item k (tip: type directly in Other / chat)`
    （`我有盘问或整改批示（提示：直接在 Other / 输入框填写可省一步）`）
- **When `k = N` (or right after presenting a batched `k+1..N` pass)**:
  - `(Recommended) Clear — generate the final Briefing Summary & Rectification List`
    （`全部听完了，生成最终《汇报总结与整改清单》`）
  - `I have questions or directives (tip: type directly in Other / chat)`
    （`我有盘问或整改批示（提示：直接在 Other / 输入框填写可省一步）`）

**Navigation & Batching rules**:
- If the leader clicks `"I have questions or directives..."` without text, ask
  a single one-line prompt (`请指示您对第 k 项的盘问点或修改要求：`) and wait.
- If the leader selects **Fast-forward (`合并精简汇报剩余第 k+1..N 项`)**,
  present items `k+1..N` concisely in one structured message (retaining line
  links, key logic/trade-offs, impact, and verification status for each), then
  open the `k = N` gate above so the leader can still question or log directives
  on any batched item before the final summary.
- If the leader types a jump/skip command in free text (e.g. `"直接讲第 4 项"`,
  `"跳过配套项直接总结"`), honor it immediately.

### 4. Handle interrogations and directives (blocking)

When the leader asks a question, challenges a choice, refers back to an earlier
item, or issues a directive:

- **Hold progression.** Stay on the target item without advancing prematurely.
- **If the leader interrogates (`盘问 / 追问细节`):**
  - Search the codebase, trace the exact call chain, or run the requested check.
  - Answer candidly with concrete file links, line ranges, and evidence. If the
    question exposes a real flaw or missed edge case, admit it plainly and offer
    to log a Rectification Item.
- **If the leader issues a directive / change request (`下达批示 / 提出整改`):**
  - **Default (Record & Confirm):** translate the instruction into a structured
    **Rectification Item (`整改项 #M`)** specifying:
    - Target item & file/symbol location
    - Leader's directive
    - Concrete modification plan
  - **Exception (Immediate Fix):** only if the leader explicitly demands an
    immediate inline fix (`"fix it right now / 现在立刻改"`), apply the edit,
    run fast targeted verification, and report the updated diff.

### 5. Single-step merged confirmation gate (no double-prompting)

After answering an interrogation, recording `整改项 #M`, or completing an
explicit inline fix, open **one merged gate** that both confirms satisfaction
and advances—never ask two separate `"is this recorded right?"` then `"move to
next item?"` prompts:

- **When `k < N`**:
  - `(Recommended) Confirmed — continue to item k+1: <next item name>`
    （`确认无误，继续汇报第 k+1 项：<下一项名称>`）
  - *(Include when `N - k >= 2`)* `Confirmed — batch remaining items (k+1..N) concisely`
    （`确认无误，合并精简汇报剩余第 k+1..N 项`）
  - `Follow up or adjust on item k (type directly in Other / chat)`
    （`继续追问或调整本项批示（直接在输入框填写）`）
- **When `k = N` (or post-batch)**:
  - `(Recommended) Confirmed — generate the final Briefing Summary & Rectification List`
    （`确认无误，生成最终《汇报总结与整改清单》`）
  - `Follow up or adjust (type directly in Other / chat)`
    （`继续追问或调整批示（直接在输入框填写）`）

### 6. Deliver the Final Briefing Summary & Rectification List

Once all items have been reviewed and confirmed, output the consolidated report
directly in the conversation (do not create a file on disk unless asked):

1. **Briefing Overview Table (`全局汇报总览表`)** — each of the `N` items, its
   tier, review status (`Approved` / `Approved (Batched)` / `Approved after Q&A`
   / `Rectification Required` / `Fixed Inline`), files involved, and key summary.
2. **Interrogation & Verification Minutes (`盘问与核实纪要`)** — concise summary
   of key questions raised by the leader and the verified conclusions (write
   `None` if no questions were asked).
3. **Leader Directives & Rectification List (`领导批示与整改清单`)** — numbered
   table of all pending directives accumulated during the session:

   | # | Briefing Item | Target Location | Leader's Directive | Concrete Action Plan |
   |---|---------------|-----------------|--------------------|----------------------|

   *(Write `None — all items approved without pending rectifications` if none.)*
4. **Unverified Items & Residual Risks (`未验证项与残留风险`)** — any checks not
   yet executed, surfaced assumptions, or edge cases requiring attention.
5. **Next-Step Decision (`后续动作请示`)** —
   - If pending rectifications exist, ask via the question tool:
     - `(Recommended) Execute the Rectification List (#1..#M) now`
       （`立即按《整改清单》逐项执行整改`）
     - `End the briefing without modifying code for now`
       （`暂不改代码，结束本次汇报`）
   - If no pending rectifications exist, hand control back cleanly without
     running `git commit` or `git push`.

### 7. Execute Rectification List & Sign Off (when approved)

If the leader selects **Execute the Rectification List now**:

1. Apply `整改项 #1..#M` in clean dependency order—strictly scoped to the
   approved action plans without sneaking in unrequested refactors.
2. Run fast, targeted verification checks on the touched scope (e.g. typecheck,
   lint, or affected unit tests) and observe real output (marking anything
   blocked or skipped as `Not verified: <reason>`).
3. Reply with a compact **Rectification Sign-Off Table (`整改核销回执表`)**:

   | # | Target Location | Changes Applied (with line links) | Verification Status |
   |---|-----------------|-----------------------------------|---------------------|

   Stop cleanly after sign-off—do not run `git commit` or `git push` unless
   explicitly instructed.

## Anti-patterns

- Dumping all `N` items in the opening turn when `N > 1` without leader fast-forward.
- Rationalizing temporary band-aids, hardcoded fallbacks, or unverified guesses
  instead of surfacing them under `Core Change & Key Trade-offs`.
- Padding minor `Supporting` items (config/types/exports) with verbose essays,
  or artificially splitting a tiny single-purpose fix into micro-items.
- Refactoring code mid-briefing when the leader gave a directive meant for the
  Rectification List, or asking two consecutive confirmation prompts to advance
  one item.
- Claiming `"no impact"` or `"tests pass"` without showing actual call-chain
  search evidence or real test execution status.
