---
name: plan-review
description: >-
  Explicit pre-implementation plan review, requirement alignment, and
  codebase-grounded course correction with low cognitive load. Inspects the
  actual codebase first to verify reality, proactively hunts blind spots and
  edge cases, pushes back candidly against flawed or over-engineered directions
  (anti-sycophancy), interviews the user only on high-leverage directional
  decisions (1 question per round by default with recommended options, letting
  the agent own low-level implementation details), and delivers a Result-First
  concrete implementation plan in chat behind a single-step sign-off gate.
  Triggers: /plan-review, "plan review", "review my plan", "align requirements",
  "stress-test my plan", "spec check", "grill-me", "grill me", "方案评审",
  "需求纠偏", "对齐需求", "梳理方案", "补全需求", "拷问方案", "评审一下方案".
license: MIT
compatibility: >-
  Works best with a structured question tool (e.g. ask_question, AskUserQuestion)
  and read-only file/search/git tools (plus optional read-only subagent for
  broad cross-module exploration); falls back gracefully to numbered plain-text
  questions with recommended answers when structured prompts are unavailable.
metadata:
  author: Ainward
  version: "1.0.0"
  status: experimental
  category: "plan-review, requirement-alignment, design-critique, software-engineering"
  verified-agents: "antigravity"
---

# Plan Review (编码前方案评审与需求纠偏)

Turn a **vague idea** or a **proposed plan** into an execution-ready,
codebase-grounded implementation plan **with minimum cognitive load**—putting
the human strictly in charge of high-level direction while the agent inspects
reality, fills blind spots, pushes back on flawed paths, and owns routine
implementation details.

## When to use

- **Explicit pre-implementation alignment**: the user runs `/plan-review` or
  explicitly asks to align requirements, fill gaps in a rough idea, or
  stress-test / review a design direction (`"方案评审"`, `"需求纠偏"`,
  `"对齐需求"`, `"grill-me"`) before writing code.
- **Both entry shapes are supported**:
  - **Vague / partial requirement**: extract missing boundaries, hidden
    dependencies, and edge cases, then resolve high-leverage directions cleanly.
  - **Existing draft / proposed approach**: verify every premise against the
    real codebase first, challenge conflicts or over-engineering candidly, and
    converge on a corrected plan.

Do **not** hijack routine, well-scoped coding requests with unsolicited
multi-round interrogations when the user did not ask for `plan-review`.
Do **not** write production code or drop unsolicited plan files to disk before
the user signs off on the final plan.

---

## Core principles

1. **Human owns direction; agent owns implementation details (`人抓大方向，AI 扛实施细节`).**
   - Escalate **only high-leverage decisions** that materially change goals,
     non-goals, user-visible behavior, public contracts/schemas, major
     architectural trade-offs, security/data integrity, or irreversible choices.
   - **Never** grill the user on low-level implementation trivia (function/file
     naming, internal helper structure, routine boilerplate, or patterns already
     established in the repository). Decide those autonomously using codebase
     conventions and surface them transparently in the final plan.

2. **Codebase-reality first & proactive course correction (`基于项目现实纠偏，先查代码库再开口`).**
   - Finding **facts** is the agent's job, never the user's. Before asking a
     single question or endorsing any feature proposal, read the real repository
     structure, relevant source files, shared utilities, and project rule files
     (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.cursor/rules/**`,
     `.agents/rules/**`).
   - Never ask the user anything answerable by inspecting the codebase.
   - If a proposed change conflicts with current architecture, duplicates an
     existing abstraction, or has a materially simpler/safer path in the real
     codebase, **point it out directly with code evidence and propose the
     corrected path**—never blindly follow a mismatched premise.

3. **Proactive blind-spot hunting (`主动补盲区`).**
   - Actively scan for what the user did **not** mention: edge cases,
     upstream/downstream callers and dependencies, state transitions,
     authz/permission boundaries, failure & retry semantics, data migration or
     backward-compatibility constraints, and cross-module side effects.
   - Cover routine defensive safeguards autonomously; raise only blind spots
     that genuinely require a human product or architectural call.

4. **Anti-sycophancy & candid pushback (`反谄媚、敢指错`).**
   - Drop hollow praise (`"很好的想法！"` / `"Great plan!"`).
   - Whenever the user's direction, scope, or trade-off has a clear defect,
     hidden blast radius, internal contradiction, or unnecessary
     over-engineering, state **three things plainly**:
     1. **What is wrong (`错在哪/隐患是什么`)**
     2. **Concrete consequence (`会导致什么后果`)**
     3. **Recommended alternative (`替代方案`)**
   - Push back once with clear evidence; if the user knowingly keeps their
     original call after hearing the consequence, respect their authority and
     record it as an accepted trade-off.

5. **Low-cognitive-load design-tree pacing (`设计树分层推进，默认单题聚焦`).**
   - Model open high-leverage choices as a dependency-ordered **design tree**:
     settle root/upstream decisions first before asking downstream branches
     (never bundle a question whose premise depends on another open question).
   - Ask **1 question per round by default** so each turn stays effortless to
     scan and decide. Batch **at most 2–3** choices into a single card **only**
     when they are genuinely lightweight, mutually independent preferences and
     combining them clearly reduces tedious back-and-forth.
   - **Every question MUST include a `(Recommended)` option** with concise
     reasoning so the user can confirm in one click.
   - Honor immediate convergence escapes (`"直接出方案"` / `"先按你建议出方案"` /
     `"skip remaining, give me the plan"`): stop interviewing at once, adopt
     your recommended defaults for remaining open branches, and tag them clearly
     in the final plan.

6. **Read-only alignment, in-chat Result-First plan, explicit sign-off (`只读对齐、对话交付、未拍板不动手`).**
   - Keep the entire discovery and alignment phase strictly **read-only**—never
     edit source code, install packages, run mutating scripts, or write
     unsolicited `PLAN*.md` scratch files to disk (avoiding workspace clutter).
   - Deliver the final concrete implementation plan **directly in chat** by
     default (write a Markdown file on disk **only** if the user explicitly asks
     to save one).
   - Close with **one** single-step sign-off card; never begin editing code
     until the user approves.

7. **Reply in the user's language.**

---

## Host adaptation

- **Structured question tool (preferred):** if the host provides a structured
  question prompt (`ask_question` in Antigravity, `AskUserQuestion` in Claude
  Code, etc.), use it for every alignment round and the final sign-off gate.
  Put the recommended answer first prefixed with `(Recommended)` and keep option
  labels crisp, concrete, and mutually distinct.
- **Plain-text fallback (hosts without structured prompts):** format each round
  cleanly and stop immediately to wait for the user's reply:
  ```text
  ❓ **Q1 — <简短标题>**：<1–3 句背景或权衡说明>
  1. **(Recommended)** <推荐选项> — <一句话理由>
  2. <备选方案 B>
  3. <备选方案 C>

  ➡️ 回复「1 / 确认」直接采用推荐方案，或回复编号 / 补充你的想法（随时可说「直接出方案」）。
  ```
- **Codebase fact-finding:**
  - For focused lookups (reading relevant modules, grep/symbol search, checking
    rule files or `git status`), inspect **directly and read-only** in the
    current session—fast and low-overhead.
  - For large, unfamiliar cross-module subsystems where the host supports
    read-only subagents (`research` / `Explore`), you may dispatch a read-only
    exploration subagent without blocking independent root questions; fall back
    to direct read-only reads when subagents are unavailable.
- **Code references:** use **short filenames** (`orderService.ts`) in normal
  prose to avoid visual clutter; attach clickable `file#L` anchors (or
  `path/file:line`) whenever citing a real codebase conflict, existing reusable
  component, or architectural pushback so the user can verify facts in one
  click.

---

## Workflow

### Step 1: Silent Reality Check & Blind-Spot Diagnosis (`代码库现实盘点与盲区诊断`)

Before asking any question:

1. **Inspect Project Reality (Read-Only)**:
   - Read repository rule/guidance files if present (`CLAUDE.md`, `AGENTS.md`,
     `GEMINI.md`, `.cursor/rules/**`, `.agents/rules/**`).
   - Locate and read the actual files, entrypoints, shared abstractions, types,
     or schemas relevant to the user's request—never speculate from filenames
     alone.
2. **Audit Assumptions, Conflicts & Blind Spots**:
   - Check whether the user's request/draft contradicts existing architecture,
     reinvents an existing helper/protocol, misses upstream callers or
     downstream consumers, or introduces over-engineering.
   - Identify genuine blind spots (boundary inputs, failure/rollback behavior,
     permissions/isolation, migration/compatibility, concurrency).
3. **Partition the Design Tree Internally**:
   - **Facts (resolved by AI)** → never ask the user.
   - **Implementation Details (owned by AI)** → decide using repo conventions;
     never grill the user.
   - **High-Leverage Open Decisions (owned by User)** → order by dependency
     (root directions first, dependent branches after).
4. **Smart Fast-Path (Skip Redundant Questions)**:
   - If **zero** genuine high-leverage ambiguities exist AND **zero**
     unconfirmed architectural conflicts remain, do **not** invent filler
     questions—state your reality check findings briefly (including any blind
     spots you proactively covered) and proceed straight to **Step 3**.

---

### Step 2: High-Leverage Alignment Loop (`分层大方向点选对齐`)

1. **Upfront Reality & Pushback Brief (Round 1 only, when applicable)**:
   - If Step 1 uncovered codebase conflicts, reusable existing components,
     critical blind spots, or a flawed/over-engineered premise, present a crisp
     **2–4 bullet brief (`现状核查与纠偏提示`)** with concrete file evidence
     right before Question 1 so the user has full context before deciding.
2. **Walk the Design Tree Round by Round**:
   - Ask **1 high-leverage question per round by default** (or **2–3** max
     only when lightweight and completely independent).
   - Keep every question focused on **direction, scope, contract, or
     risk/trade-off**—include a clear `(Recommended)` first option and concise
     trade-off note only when non-obvious.
   - Recompute the tree after each answer: if a user answer introduces a new
     codebase area or assumption, inspect the real files read-only before asking
     the next branch.
   - If the user picks a path with a serious flaw or contradiction, give **one**
     concise candid pushback (cause → consequence → alternative) before moving
     on; if reaffirmed, honor their call.
   - Stop interviewing as soon as all high-leverage branches are settled—or
     immediately if the user asks to jump straight to the plan (`"直接出方案"`).

---

### Step 3: Result-First Concrete Implementation Plan & Single-Step Sign-Off (`具体实施方案交付与单步拍板`)

Synthesize one clean, scannable, execution-ready plan **directly in chat** (no
disk writes unless explicitly requested):

1. **目标与非目标 (`Goal & Non-Goals`)** *(2–3 crisp lines)*
   - What problem is being solved, expected outcome, and what is explicitly out
     of scope.
2. **已拍板的核心方向 (`Aligned Decisions`)**
   - Bullet summary of settled high-leverage decisions *(tag any item
     auto-settled via recommended default if the user ended early, e.g.
     `[默认采纳推荐]`)*.
3. **现实纠偏与补齐的盲区 (`Reality Corrections & Filled Blind Spots`)** *(Omit completely if none)*
   - Codebase conflicts corrected, over-engineering/flawed paths avoided, and
     edge cases/dependencies/failure semantics proactively covered (with short
     file refs or `file#L` anchors).
4. **AI 自主决策的实施细节 (`Agent-Owned Implementation Details`)**
   - Concrete modules/files to create or modify (short filenames), existing
     project abstractions reused, key internal design choices, and error/state
     handling conventions—transparent so the user can spot-check without having
     been grilled on minutiae.
5. **分步实施与验收验证 (`Execution Steps & Verification`)**
   - Ordered, actionable implementation steps (`1..N`).
   - Concrete acceptance criteria and targeted verification commands/checks
     *(written cleanly so they also serve as `Original Requirement Context` for
     downstream `/agent-review` and `/work-report`)*.

**Single-Step Sign-Off Gate (`单步拍板卡`)**:

Immediately open **ONE** `ask_question` card (or numbered options if
unavailable):

- `(Recommended) 确认方案，立即按此开始实施` (`Approve plan and start implementation now`)
- `微调方案中的部分内容（在 Other 说明要改的点）` (`Adjust part of the plan (describe edits in Other)`)
- `仅保留方案，暂不动手写代码` (`Keep the plan as-is — do not edit code yet`)

**Post-Gate Handling**:
- **Approve**: execute the agreed implementation plan cleanly, run the planned
  targeted checks, and never run `git commit` or `git push` unless explicitly
  instructed.
- **Adjust**: update only the requested parts of the plan in chat (re-checking
  the codebase read-only if needed) and re-open the sign-off gate.
- **Keep plan only**: stop cleanly with zero file edits. If the user explicitly
  asks to save the plan to a Markdown file, write it only to the confirmed path.

---

## Anti-patterns

- Grilling the user on low-level implementation details (naming, helper splits,
  routine boilerplate, or existing repo conventions) instead of owning those
  decisions autonomously.
- Asking the user facts that can be verified directly from the codebase, or
  endorsing a proposed design without checking actual repo architecture first.
- Sycophantic praise (`"很棒的想法！"`) or silent compliance when a direction
  has clear defects, architectural conflicts, or unnecessary over-engineering.
- Dumping 5–8 questions in a single overwhelming wall of text, or asking
  downstream questions whose prerequisites are still unsettled.
- Omitting a clear `(Recommended)` option or forcing the user to type free-form
  answers when a structured question card is available.
- Writing code or creating unsolicited `PLAN*.md` files on disk before the user
  explicitly signs off on the final plan.
- Hijacking simple, already-clear coding prompts with unsolicited `plan-review`
  interrogations when the user did not invoke the skill.
