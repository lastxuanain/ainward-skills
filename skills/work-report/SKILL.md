---
name: work-report
description: >-
  Result-First, low-friction change walkthrough and handoff briefing after
  implementing or modifying code. Anchors scope, delivers a single scannable
  screen of grouped plain-language changes (with short filenames, candidly
  surfaced compromises/assumptions, and real verification status—without
  repeating independent call-chain audits or forcing 1-by-1 modal popups),
  answers drill-downs with clickable code proof, and executes follow-up edits
  directly.
  Triggers: /work-report, "work report", "step-by-step report", "walk me through
  the changes", "brief me on the changes", "工作汇报", "向我汇报", "逐项汇报",
  "汇报一下这次改动", "复盘一下代码", "一步一步汇报".
license: MIT
compatibility: >-
  Works on any coding agent with file-read and optional shell access (for
  git diff / status inspection and requested verification or follow-up edits).
metadata:
  author: Ainward
  version: "2.0.0"
  status: experimental
  category: "agent-workflow, change-walkthrough, software-engineering"
  verified-agents: "antigravity"
---

# Work Report (改动交底与走读)

Give the developer a **clear, honest, one-screen walkthrough** of completed or
modified code—acting as a collaborative peer engineer handing off work rather
than dumping a wall of self-congratulatory text or trapping them in a
turn-by-turn bureaucratic interrogation.

## When to use

- Code features, bug fixes, or refactors have already been implemented or
  modified (in the current conversation, working tree, or specified commits /
  branch), and the user wants to understand what changed, what compromises or
  assumptions exist, and what has or hasn't been verified.
- The user wants to review the changes at a glance, drill down on specific
  parts, or request adjustments.

Do **not** use this skill as an independent bug/regression auditor—leave
3D call-chain verification and `"fix A, break B"` checks to `agent-review`.
Do **not** use this skill to start building a brand-new feature from scratch.

---

## Core principles

1. **One-screen `Result-First` overview by default (zero modal click tax).**
   Present all grouped change items together in **one scannable screen** and
   end cleanly with **zero modal popups (`ask_question`)**. Switch to
   item-by-item walkthrough **only** if the user explicitly asks for it (e.g.,
   `"一步一步讲"` / `"walk through one by one"`).

2. **Plain collaborative language—no hierarchy theater, no `#L` clutter.**
   Speak like a peer developer explaining changes clearly—never use
   subordinate/leader metaphors (`下属汇报 / 领导批示 / 过堂 / 核销`) or
   architectural jargon dumps. By default, show **short filenames** per item
   while hiding `#L` line numbers and class/symbol inventories; keep exact file
   paths and line ranges in working memory to answer `"展开 #X"` or follow-up
   questions immediately.

3. **Surface shortcuts, assumptions, and unverified gaps upfront.**
   Never disguise temporary workarounds, hardcoded fallbacks, or implicit
   assumptions as ideal architecture. Highlight them candidly so the developer's
   eye goes straight to what needs attention. Report verification strictly from
   observed runs; mark anything unrun as `Not verified: <reason>` (or
   `未验证（<原因>）`).

4. **Strict boundary with `agent-review` (no self-reviewing call chains).**
   The agent that just wrote code carries confirmation bias. Focus strictly on
   **what changed, why, trade-offs/assumptions, and verification status**—do
   **not** run or claim full 3D upstream/downstream regression audits here. If
   the developer wants independent bug or `"fix A, break B"` verification, point
   them to `/agent-review`.

5. **Direct follow-up loop (no `Rectification List` ceremony).**
   When the user asks a question, answer with concrete clickable code proof.
   When the user asks to change something, **apply the modification directly**
   (unless genuinely ambiguous or high-risk), run fast targeted verification on
   the edit, and reply with a concise updated result—never force a multi-turn
   "log into list → confirm list → execute → sign-off table" loop.

6. **Fast, read-only default; reply in the user's language.**
   Do not stall the overview with unprompted slow full test suites, do not write
   summary files to disk, and never run `git commit` or `git push` unless
   explicitly instructed.

---

## Host adaptation

- **Code references:**
  - In the default one-screen overview, list **short filenames** (e.g.
    `orderService.ts, retryPolicy.ts`) without `#L` line dumps.
  - Whenever answering follow-up questions or expanding details (`"展开 #X"` /
    `"展开细节"`), provide clickable file + line-range links when supported
    (e.g. `[orderService.ts#L42-L58](file:///abs/path/orderService.ts#L42-L58)`),
    otherwise `path/to/orderService.ts:42-58`.

---

## Workflow

### Step 1: Resolve Scope & Group Cohesively

1. **Smart Scope Resolution** *(in priority order)*:
   - **Explicit scope**: specific files, modules, commits, or branches named by
     the user.
   - **Session-anchored changes**: files created, modified, or deleted earlier
     in **this conversation** *(if `git status` shows unrelated dirty files
     from parallel work, ignore them and add at most a brief 1-line note that
     unrelated workspace edits were excluded)*.
   - **Workspace / HEAD fallback**: uncommitted workspace diffs (`git status` /
     `git diff`), falling back to `git show --stat HEAD` & `git show HEAD` when
     the working tree is clean.

2. **Cohesive Functional Grouping (`#1..#N`)**:
   - Group changes by **functional or module boundary** (core logic first,
     supporting wiring/types/config/tests after)—never split mechanically file
     by file.
   - Keep `N = 1` for a single small, focused fix (do not artificially slice
     tiny changes).
   - Keep `Supporting` items (`配套改动`, e.g. types, exports, config, copy)
     compact—1 tight bullet without boilerplate.

---

### Step 2: Deliver the One-Screen `Result-First` Walkthrough

Output one clean, scannable response with the following structure (omitting
sections that have nothing to flag):

1. **Headline (`改动总括`, 1–2 lines)**
   - Goal/completion status, total modules/files touched (`共 N 块 / X 个文件`),
     overall verification status, and whether any compromises or unverified
     items need attention.

2. **Grouped Change Digest (`改动说明`, `#1..#N`)**
   For each item:
   - **Header**: `#k <Plain-Language Functional Title>` (`<short filenames>`)
     *(tag `[配套]` concisely if minor wiring/types/config; omit noisy tags on
     ordinary items)*.
   - **What changed & why (`改了什么`)**: 1–3 plain sentences explaining before
     vs. after functionally (what problem it solves or behavior it changes).
   - **Trade-offs / Assumptions (`取舍与假设`)**: include **only** when a design
     compromise, hardcoded value, temporary workaround, or implicit assumption
     exists (highlight clearly with `⚠️` so it stands out). Omit this line when
     the change is straightforward!
   - **Verification (`验证情况`)**: real observed check outcome (e.g.
     `单测通过` / `tsc --noEmit 通过`), or candidly `未验证（<原因>）`.

   *(Keep `Supporting` items even tighter: `#k [配套] <summary> (<short filenames>) — <verification>`.)*

3. **Needs Attention (`需要留意的点`)** *(Omit completely when there are zero compromises/assumptions and zero unverified items!)*
   - Bullet summary of only the surfaced `⚠️` compromises/assumptions and
     unverified checks so the developer can scan every risk in 2 seconds.

4. **Closing Hint (1 line — ZERO modal popup)**
   - End the turn cleanly without calling `ask_question`:
     `如需看某项的代码行号细节（回复“展开 #编号”或“展开细节”）、追问原因或直接调整实现，告诉我即可；如需独立排查隐患与跨模块影响，可运行 /agent-review。`

---

### Step 3: Interactive Follow-Up Loop (Drill-Down, Q&A, or Direct Edits)

Handle whatever the user asks next seamlessly:

1. **On-Demand Detail Expansion (`"展开 #k"` / `"展开细节"` / `"一步一步讲"`)**:
   - **For `"展开 #k"` / `"展开细节"`**: immediately output clickable `file#L`
     links, exact symbol names, and technical before/after logic from working
     memory (or re-read the files if needed).
   - **For explicit `"一步一步讲"` / `"逐项展开"`**: switch to walking through
     the remaining items interactively one at a time until finished.

2. **Questions (`追问原因 / 边界细节`)**:
   - Inspect the relevant source lines directly (never guess from memory) and
     reply concisely with clickable `file#L` evidence. If the question exposes
     a genuine flaw or missed edge case, acknowledge it plainly and ask whether
     to fix it directly.

3. **Direct Modification Instructions (`直接调整实现`)**:
   - Apply the requested edit directly—scoped strictly to what the user asked
     without sneaking in unrelated refactors.
   - *(Pause to confirm first ONLY if the requested change is genuinely
     ambiguous or high-risk/destructive.)*
   - Run fast, targeted checks on the modified scope (marking any blocked
     check as `Not verified: <reason>`), then report in 2–4 crisp lines: what
     changed (with short filename/link) and real verification outcome.
   - Never run `git commit` or `git push` unless explicitly instructed.

---

## Anti-patterns

- Opening turn-by-turn `ask_question` modal gates (`Item 1 of N`, `Item 2 of N`)
  by default instead of delivering one scannable screen.
- Using subordinate/leader phrasing (`领导批示 / 过堂 / 整改清单 / 核销回执表`)
  or dumping `#L` line walls and symbol inventories in the default overview.
- Performing self-reviewed call-chain / `"no downstream impact"` claims inside
  `work-report` instead of leaving independent regression checks to
  `agent-review`.
- Deferring simple follow-up edit instructions into a staged `Rectification List`
  when all items are already on screen.
- Rationalizing shortcuts/band-aids or claiming `"tests pass"` without observed
  output.
