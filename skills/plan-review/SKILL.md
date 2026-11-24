---
name: plan-review
description: >-
  Pre-code alignment: reads codebase, restates root problem & goal, and delivers
  a complete, self-contained execution plan. Triggers: /plan-review, "plan
  review", "align requirements", "in-your-own-words", "方案评审", "需求纠偏", "对齐需求",
  "复述需求".
license: MIT
metadata:
  author: ainward
  version: "2.1.0"
---

# Plan Review (编码前本意对焦与完整执行方案收敛)

Align on **the real problem, explicit boundaries, and a complete, self-contained
execution plan** before writing code—grounding every file, contract, step, and
verification command in repository reality while converging in **1 turn by
default** (`2` turns max when genuine blocking forks exist) with zero questionnaire
theater or prose fluff.

## When to use & hard pre-code invariants

- Explicit pre-coding alignment on a **vague idea**, a **noisy bug/chat thread**,
  or an **unverified plan / prescribed solution**. Never hijack clear, routine
  coding prompts when uninvoked.
- **100% read-only until the complete plan is confirmed**: **NEVER** edit code
  or run mutating commands in the same turn that first outputs the complete
  execution plan—even if the user initially said `"对齐完直接改"` or just
  answered a blocking fork.
- **In-chat delivery, zero sign-off popups**: Deliver the plan strictly in chat
  (never write `PLAN*.md` files to disk unless the user explicitly specifies a
  file path), ending with **1 plain-text confirmation line** and **zero
  sign-off modal popups**.

## Workflow

### Step 1: Silent 3D Recon, XY Audit & Strict Fork Filter (Read-Only)

1. **Ground every claim in repo reality**: Inspect repo rules (`CLAUDE.md`,
   `AGENTS.md`, `GEMINI.md`, `.cursor/rules/**`, `.agents/rules/**`), target
   modules, shared helpers, **direct upstream/downstream callers, companion
   types/schemas/configs, and actual build/test scripts** (`package.json`,
   `Makefile`, `pyproject.toml`, `Cargo.toml`, test directories) read-only
   (spawning a read-only subagent only when a broad unfamiliar subsystem
   requires it). **Never** ask facts verifiable from the repository.
2. **Penetrate XY problems & lock boundaries**: Separate any user-prescribed
   mechanism (`Y`) from the underlying pain/blocker (`Problem` / `X`) and
   desired observable outcome (`Goal`), and identify explicit `Non-Goals` so
   scope never creeps silently.
3. **Strict Fork Filter (manage by exception)**:
   - **Own secondary choices autonomously**: Decide naming, file layout, repo
     conventions, and clear-winner design trade-offs yourself, folding them and
     their safeguards directly into the plan.
   - **Escalate ONLY `1–2` genuine blocking forks (`0` in most tasks)**: Ask
     upfront **only** when 2+ viable paths materially alter user-visible
     behavior, public contracts, irreversible data/security risk, or the core
     meaning of an ambiguous prompt, **and** codebase facts cannot settle it.

### Step 2: Convergence & Self-Contained Complete Execution Plan

Use **compact clickable basename links** (`[orderService.ts](file:///abs/path/orderService.ts#L42-L58)`
when supported; `path/orderService.ts:42-58` fallback; ban raw full-path walls
and symbol dumps). Reply in the user's language with zero hollow praise (`"很好的想法"`):

- **Restate-Only Exit *(only when explicitly asked to clarify/restate without planning yet)***:
  Output **2–3 plain sentences in your own words** (`Problem` + `Goal` + any
  `[file.ts](file:///...#L...)` reality/XY note), and stop with zero popups.

- **When `1–2` Blocking Forks Exist (2-Turn Convergence)**:
  - **Turn 1**: Output **本意还原** (2–3 plain sentences, zero parroting) + any
    **现实纠偏** (`[file.ts](file:///...#L...)` proof), then call `ask_question`
    (or numbered fallback) for **only** the `1–2` forks (`(Recommended)` first
    with a 1-phrase reason, zero strawmen, zero manual `Other` option since the
    UI adds `Other` natively). Do **not** pre-write a speculative half-plan.
  - **Turn 2 (after fork answer)**: Output **one standalone, self-contained
    Complete Execution Blueprint** in a single message (folding the settled goal
    + fork decisions cleanly into Element 1 so this single message stands on its
    own after `/compact` or agent handoff, without conversational filler) and
    **stop at the 1-line plain-text gate** before touching code.

- **The Complete Execution Blueprint (`0` Forks on Turn 1, or Turn 2 Post-Fork)**
  *(Cut prose filler, NEVER cut these 4 closed-loop elements; keep compact on
  1–2 file tasks and fully itemized on multi-file tasks)*:
  1. **本意、纠偏与边界 (`Intent, Course Correction & Non-Goals`)**: 2–3 plain
     sentences in your own words stating root `Problem` + observable `Goal`
     *(plus settled fork decision on Turn 2)*, **explicit `Non-Goals` (明确不碰的范围)**,
     and candid `[file.ts](file:///...#L...)` pushback (`错在哪 → 后果 → 更优解`)
     whenever a premise conflicts with repo reality or reinvents existing helpers
     (push back once; respect informed overrides).
  2. **全量改动文件与契约清单 (`Complete File & Contract Inventory`)**: Exhaustive
     list of every touched file tagged **`[新增]` / `[修改]` / `[删除]`** with
     clickable `[file.ts](file:///abs/path/file.ts#L...)` links (`path/file.ts:line`
     fallback), exact responsibility, and key signature/type/schema/state
     contract changes (covering core logic, callers, configs, and tests).
     **Anti-handwaving #1**: strictly ban `"等相关文件"`, `"按需调整调用方"`, or
     path wildcards (`src/services/*`).
  3. **有序执行步骤与兜底 (`Ordered Execution Steps 1..N`)**: Dependency-ordered
     steps (`1 → 2 → ... → N`). **Anti-handwaving #2**: every step must specify
     concrete contract/state/logic changes and AI-owned error, edge-case,
     compatibility, or concurrency safeguards so execution requires zero guesswork.
  4. **可执行验收方案 (`Executable Verification Plan`)**: **Anti-handwaving #3**:
     provide exact copy-pasteable commands verified from repo scripts +
     observable pass criteria; if no automated test infra exists for that layer,
     explicitly state `无现成自动化测试基建 -> 具体 CLI / 手动验证路径与预期表现`
     (strictly ban vague `"运行相关单测"` filler).

  End with **1 plain-text stop line**: `确认即可按此计划实施，或直接指出微调点。`
  *(If the user requests tweaks, output an updated self-contained blueprint in
  chat and pause again until explicitly confirmed.)*

### Step 3: Post-Approval Execution

Once the user confirms the complete plan, execute Steps `1..N` cleanly, run the
stated verification plan, and never run `git commit` or `git push` unless instructed.
