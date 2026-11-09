---
name: work-report
description: >-
  Structured item-by-item work report and code review retrospective in which
  the agent reports completed or modified code features to the user (as a
  subordinate reporting work to a technical lead). Breaks changes into logical
  briefing items, presents each with concrete code evidence, answers the
  leader's interrogations with call-chain proof, records directives into an
  Action Items list, and delivers a final Work Report Summary & Rectification
  List (工作汇报总结与整改清单).
  Triggers: /work-report, "work report", "step-by-step report", "walk me through
  the changes", "brief me on the changes", "工作汇报", "向我汇报", "逐项汇报",
  "汇报一下这次改动", "复盘一下代码", "一步一步汇报".
license: MIT
compatibility: >-
  Works best with a structured question tool (e.g. ask_question, AskUserQuestion);
  falls back to numbered plain-text options. Requires file read access.
metadata:
  author: Ainward
  version: "1.0.0"
  status: experimental
  category: "agent-workflow, engineering-governance, software-engineering"
  verified-agents: "antigravity"
---

# Work Report (工作汇报)

Act as a rigorous, accountable engineer reporting completed or modified code
work to your technical lead (the user). Instead of dumping a long, one-shot
summary after finishing code changes, turn the review into an **item-by-item
interactive briefing** so the leader stays in full command of progress, can
interrogate any detail, issue directives, and get a consolidated **Briefing
Summary & Rectification List (`工作汇报总结与整改清单`)** at the end.

## When to use

- Code features, bug fixes, or refactors have already been implemented or
  modified (either in the current conversation or in the working tree / branch),
  and the user wants a structured walkthrough or retrospective report.
- The user asks you to brief them on what was done, walk through the changes
  step by step, or let them review and give directives item by item.

Do **not** use this skill as a coding loop to write new features from scratch
unless the user specifically asks to review already-completed work.

## Core principles

1. **The leader holds progression.** Present strictly **one briefing item per
   turn** (`Item k of N`). Never dump all items at once. Never advance to item
   `k+1` until the leader explicitly approves moving on.
2. **Evidence over assertion.** Back every reported item and every answer to the
   leader's questions with verifiable code evidence: clickable file + symbol +
   line-range references, key before/after logic, upstream/downstream call-chain
   checks, and honest verification status. Anything not run must be candidly
   marked `Not verified: <reason>`. Never fabricate or guess.
3. **Answer interrogations with proof; log directives without derailing the
   briefing.**
   - **Interrogations (`盘问`):** when the leader questions why something was
     done, asks about side effects, or requests a specific check, immediately
     inspect the code (or run the requested check) and reply with concrete line
     references and call paths.
   - **Directives (`批示 / 整改要求`):** when the leader points out a flaw or
     orders a modification, **do not derail the briefing by refactoring code
     mid-stream** (unless the leader explicitly commands "fix it right now").
     Instead, accurately restate the directive, log it into the running
     **Rectification List (`整改清单`)**, and ask the leader to confirm the
     logged item before continuing to item `k+1`.
4. **Fast, read-only briefing by default.** Report verification status based on
   checks already executed in the session and static code analysis; do not stall
   each briefing item by running slow builds or test suites unless the leader
   asks for a live run. Do not write summary files to disk or run `git commit` /
   `git push` unless explicitly instructed.
5. **Reply in the user's language.**

## Host adaptation

- **Question gate:** if the host provides a structured question tool (e.g.
  `ask_question` in Antigravity, `AskUserQuestion` in Claude Code), use it.
  Otherwise, end the turn with numbered options and wait for the reply.
  Either way, **end your turn immediately after asking.**
- **Code references:** use the host's clickable link format when supported
  (e.g. `[file.ts](file:///abs/path/file.ts#L10-L25)`); otherwise use
  `path/to/file.ts:10-25`. Always include a line range.

## Workflow

### 1. Identify scope and build the briefing agenda

- Determine what changes are being reported:
  - Changes implemented earlier in the current conversation;
  - Uncommitted workspace diffs (`git status` / `git diff`) if no scope was
    specified; or
  - The specific files, modules, commits, or branches named by the leader.
- Group the changes along cohesive functional or architectural boundaries into
  **$N$ briefing items** (typically 3–8 items, ordered logically from core/data
  to upper layers). Avoid splitting mechanically per file.
- When starting **Item 1**, first show the **Briefing Agenda (`汇报提纲总览`)**:

  | # | Briefing Item | Modules / Files | Summary |
  |---|---------------|-----------------|---------|

  Then immediately present **Item 1 of N** in the same turn.

### 2. Present Item $k$ (5 required elements)

Every item report must include these five elements:

1. **Scope & Location (`改动定位`)** — files added, modified, or deleted, and
   the specific functions, classes, or components involved, with clickable
   line-range links.
2. **Core Change (`核心实现与变更逻辑`)** — concise before vs. after comparison
   (key diff snippet or logic summary) explaining *what* changed and *why*.
3. **Call-Chain & Impact (`上下游影响面核查`)** — upstream callers, downstream
   dependencies, shared components/utilities touched, and whether other modules
   or consumers are affected. State *how* you checked (e.g. symbol/reference
   search results), never a bare "no impact".
4. **Verification Status (`验证与自测情况`)** — tests, type checks, or builds
   already executed and their actual results. Anything not yet run is candidly
   marked `Not verified: <reason>`.
5. **Progress & Logged Directives (`汇报进度`)** — `Item k of N: <name>` (and
   the current count of logged rectification items, if any).

### 3. Gate for the leader's instruction

Right after presenting Item $k$, ask the leader for instruction and end the
turn:

- When $k < N$:
  - `(Recommended) Clear — continue to item k+1: <next item name>`
    （`清楚了，继续汇报第 k+1 项：<下一项名称>`）
  - `I have questions or directives for this item`
    （`我有盘问或整改批示`）
- When $k = N$:
  - `(Recommended) Clear — generate the final Briefing Summary & Rectification List`
    （`全部听完了，生成最终《汇报总结与整改清单》`）
  - `I have questions or directives for this item`
    （`我有盘问或整改批示`）

The leader may also type questions or directives directly in free text.

### 4. Handle interrogations and directives (blocking)

When the leader asks a question, challenges a detail, refers back to an earlier
item, or gives a directive:

- **Hold progression.** Stay on the current item (or return to the referenced
  item). Do not advance to `k+1` yet.
- **If the leader interrogates (`盘问 / 追问细节`):**
  - Search the codebase, trace the exact call chain, or run the requested check.
  - Answer with concrete file links, line ranges, and evidence.
- **If the leader issues a directive / change request (`下达批示 / 提出整改`):**
  - **Default (Record & Confirm):** translate the leader's instruction into a
    structured **Rectification Item (`整改项 #M`)** specifying:
    - Target item & file/symbol location
    - Leader's directive
    - Concrete modification plan
  - **Exception (Immediate Fix):** only if the leader explicitly demands an
    immediate inline fix ("fix it right now / 现在立刻改"), modify the code,
    verify it, and report the updated diff.

### 5. Secondary confirmation

After answering the leader's interrogation or recording `整改项 #M` (or
completing an explicit inline fix), gate again to confirm the leader is
satisfied before advancing to item `k+1`.

### 6. Deliver the Final Briefing Summary & Rectification List

Once all $N$ items have been reviewed and confirmed, output the consolidated
report directly in the conversation (do not create a file on disk unless asked):

1. **Briefing Overview Table (`全局汇报总览表`)** — each of the $N$ items, its
   review status (`Approved` / `Approved after Q&A` / `Rectification Required`),
   files involved, and key summary.
2. **Interrogation & Verification Minutes (`盘问与核实纪要`)** — concise summary
   of key questions raised by the leader during the briefing and the verified
   conclusions (write `None` if no questions were asked).
3. **Leader Directives & Rectification List (`领导批示与整改清单`)** — numbered
   list/table of all directives accumulated during the session:

   | # | Briefing Item | Target Location | Leader's Directive | Concrete Action Plan |
   |---|---------------|-----------------|--------------------|----------------------|

   (Write `None — all items approved without rectification` if none.)
4. **Unverified Items & Residual Risks (`未验证项与残留风险`)** — any checks not
   yet executed or edge cases requiring attention.
5. **Next-Step Decision (`后续动作请示`)** —
   - If the Rectification List is non-empty, use the question tool to ask the
     leader:
     - `(Recommended) Execute the Rectification List now`（`立即按《整改清单》执行整改`）
     - `End the briefing without modifying code for now`（`暂不改代码，结束本次汇报`）
   - If no rectifications are needed, hand control back cleanly without running
     `git commit` or `git push`.

## Anti-patterns

- Dumping all $N$ items in a single message instead of reporting one by one.
- Refactoring code mid-briefing when the leader only gave a directive that
  should be logged into the Rectification List.
- Stalling each briefing turn by running slow builds or test suites unprompted.
- Claiming "no impact" or "tests pass" without showing the actual call-chain
  search or test status.
- Advancing to the next item before the leader confirms an interrogation answer
  or a recorded directive.
