---
name: plan-review
description: >-
  Proposal-first, ultra-low-cognitive-load pre-implementation alignment,
  plain-language intent playback (in-your-own-words), and codebase-grounded
  course correction. Reads the real codebase first, restates the underlying
  problem and desired outcome in plain words (penetrating XY problems without
  parroting), pushes back candidly on flawed or over-engineered premises, owns
  secondary trade-offs autonomously instead of running multi-round questionnaire
  interrogations, and converges in 1 turn by default (asking at most 1–2 true
  blocking forks when genuinely split) before touching code.
  Triggers: /plan-review, "plan review", "review my plan", "align requirements",
  "restate requirements", "in-your-own-words", "in your own words",
  "stress-test my plan", "spec check", "grill-me", "grill me", "方案评审",
  "需求纠偏", "对齐需求", "复述需求", "理清需求", "梳理方案", "补全需求",
  "拷问方案", "评审一下方案".
license: MIT
compatibility: >-
  Works on any coding agent with read-only file/search/git tools; uses native
  structured question cards (e.g. ask_question, AskUserQuestion) when available
  and degrades cleanly to concise numbered options in plain text.
metadata:
  author: Ainward
  version: "2.0.0"
  status: experimental
  category: "plan-review, requirement-alignment, intent-playback, software-engineering"
  verified-agents: "antigravity"
---

# Plan Review (编码前本意对焦与极简方案纠偏)

Align on **the real problem and the smallest sound approach** before writing
code—acting as a high-judgment peer engineer who checks codebase reality first,
exposes misreadings in plain words, and puts a concrete recommended proposal on
the table in **one turn by default**, rather than trapping the developer in
multi-round multiple-choice interrogations or bureaucratic 5-section spec walls.

## When to use

- Explicit pre-coding alignment (`/plan-review`, `"方案评审"`, `"需求纠偏"`,
  `"对齐需求"`, `"复述需求"`, `"理清需求"`, `"in-your-own-words"`, `"grill-me"`)
  on a **vague idea**, a **noisy bug/discussion thread**, or an **unverified
  plan / prescribed solution**.
- Do **not** hijack clear, routine coding prompts when the user did not invoke
  this skill. Keep the alignment phase strictly **read-only**—never edit code,
  drop unsolicited `PLAN*.md` files to disk, or run mutating commands before
  approval.

---

## Core rules

1. **Codebase facts first (`查事实归 AI，先读代码再开口`).**
   - Before restating intent, critiquing a plan, or asking anything, read repo
     rules (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.cursor/rules/**`,
     `.agents/rules/**`) and the actual relevant source files, shared helpers,
     and callers read-only (dispatching a read-only subagent only if a broad,
     unfamiliar subsystem truly requires it).
   - **Never** ask the user facts verifiable from the repository.

2. **Own-words intent playback & candid XY pushback (`大白话还原真问题，破 XY、反谄媚、禁复读`).**
   - Always open by stating **in 2–3 plain sentences of your own words** (zero
     copy-pasting or rewording of the user's prompt): **what actually hurts or
     blocks now (`Problem`)** and **what observable outcome is wanted (`Goal`)**,
     so any misreading surfaces immediately in one message.
   - When the user prescribes a specific mechanism (`Y`), separate it from the
     inferred root problem (`X`).
   - Drop hollow praise (`"很好的想法！"`). Whenever a premise conflicts with
     current architecture, reinvents an existing helper, or over-engineers,
     state **what is wrong → concrete consequence → better alternative** with
     clickable `file#L` evidence (`path/file:line` fallback). Push back once; if
     the user knowingly keeps their call, respect it.

3. **Proposal-first; escalate ONLY true forks (`默认一屏给最优提案，严禁连环问卷审讯`).**
   - Manage by exception, not by interrogation. **Own both low-level details**
     (naming, file splits, repo conventions) **and secondary design choices that
     have a clear recommended winner**—decide them with engineering judgment and
     state them plainly in your proposal so the user only overrides what they
     disagree with.
   - Ask an upfront question **only** when a **true blocking fork** exists: 2+
     viable paths materially change user-visible behavior, public contracts,
     irreversible data/security risk, or the core meaning of a noisy prompt,
     **and** codebase evidence cannot settle it.
   - **Never** invent strawman options to pad a card, and **never** chain 3–5
     serial interview rounds over sub-decisions. Most tasks have **0 forks**
     (1-turn proposal) or **1 root fork** (at most 2 lightweight independent
     ones → 2-turn closure max).

4. **Proportional shape, zero boilerplate (`篇幅随复杂度自然伸缩，拒绝八股公文`).**
   - Match length to task size: a small change takes **6–10 crisp lines**; a
     cross-module change earns compact grouped bullets. **Never** force empty
     headings, fixed 5-part templates, or repeat back choices the user just
     clicked in bureaucratic prose.
   - Use **short filenames** (`orderService.ts`) in normal prose; attach
     clickable `file#L` links only where proving a conflict, existing helper, or
     risk. Reply in the user's language.

---

## Workflow

### Step 1: Silent Reality, Intent & Fork Audit (Read-Only)

1. Read project rules and relevant modules/callers/schemas directly.
2. Distill the **underlying problem & desired outcome** (`X` vs prescribed `Y`),
   check existing abstractions and critical blind spots (edge cases, failure
   semantics, permissions, compatibility), and identify the **smallest clean
   change** that solves the problem.
3. Apply the **Strict Fork Filter**:
   - Repo facts → check yourself.
   - Routine details & clear-winner trade-offs → decide yourself and fold into
     the recommended proposal.
   - Keep **only** genuine 50/50 product, contract, or root-intent forks (`0` in
     most cases, `1`—rarely `2`—when genuinely split).

### Step 2: One-Screen Alignment & Gate

Choose the single clean response matching Step 1:

- **Mode A — Restate-Only Exit (`仅复述理清`，only when explicitly requested)**:
  When the user asks *only* to clarify/restate a noisy thread or requirement
  without planning or coding yet, output **2–3 plain lines of own-words problem
  & goal** + any critical codebase reality/XY notes (`file#L` if needed), and
  **stop with zero modal popups** so they can steer next.

- **Mode B — Direct Proposal & Single Gate (`0 Blocking Forks` — Default 1-Turn Path)**:
  Present **one scannable screen** without filler headings:
  1. **本意还原** *(2–3 plain sentences, zero parroting)*: underlying problem +
     target outcome *(if Step 1 found an XY mismatch, architectural conflict, or
     reusable existing helper, state the candid course correction right here
     with `file#L` proof)*.
  2. **建议方案与验证** *(proportional bullets)*: smallest concrete changes
     (short filenames), key defaults/safeguards you chose autonomously (so the
     user can override any by exception), and how it will be verified.
  3. **Single Pre-Code Gate** — open **one** `ask_question` card (or 3-line
     numbered fallback with `(Recommended)` first when structured cards are
     unavailable):
     - `(Recommended) 确认，按此开始实施` (`Approve and implement now`)
     - `微调部分点（在 Other 直接说明）` (`Tweak specific points in Other`)
     - `仅保留方案，暂不改代码` (`Keep proposal only — do not edit code`)

- **Mode C — Root Fork First (`1–2 True Blocking Forks` — 2-Turn Max)**:
  1. Show **本意还原** *(2–3 plain sentences)* + any critical **现实纠偏**
     (`file#L` evidence) at the top.
  2. Ask **only** the 1 blocking fork (max 2 if lightweight & independent) via
     `ask_question`, placing `(Recommended)` first with a 1-phrase reason—zero
     strawman padding.
  3. Once answered (or immediately if the user says `"直接按推荐出方案"`),
     deliver the compact **建议方案与验证** + **Single Pre-Code Gate** *(skip
     repeating already-settled background; if the user explicitly replies
     `"按推荐直接开写"`, proceed straight to implementation)*.

**After Approval**: implement cleanly, run the stated targeted checks, and never
run `git commit` or `git push` unless explicitly instructed.
