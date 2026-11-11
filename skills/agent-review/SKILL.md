---
name: agent-review
description: >-
  Independent, read-only full-chain code review and 3D call-graph regression
  analysis delegated to an isolated subagent. Goes beyond raw diffs by tracing
  upstream callers, downstream dependencies, and lateral shared-component reuse
  ("fix A, break B"), auditing end-to-end closed loops, single-source-of-truth &
  cross-boundary mapping consistency, architecture/authz/state boundaries,
  silent fallbacks, temporary band-aids/duplicate implementations/dead code, and
  related unmodified files. Outputs P0/P1/P2 findings without modifying code.
  Triggers: /agent-review, "agent review", "code review", "independent review",
  "review my changes", "what does this affect", "who calls", "审查一下",
  "独立审查", "帮我看看这次改动", "改动会影响什么", "谁调用了".
license: MIT
compatibility: >-
  Works best on hosts supporting subagents (e.g. define_subagent/invoke_subagent,
  Agent/Task tool, or custom subagents) plus read-only shell and file-read tools;
  falls back to an explicitly disclosed zero-assumption single-session review when
  subagents are unavailable.
metadata:
  author: Ainward
  version: "1.0.0"
  status: experimental
  category: "code-review, architecture-audit, regression-analysis, software-engineering"
  verified-agents: "antigravity"
---

# Agent Review (全链路独立代码审查与三维影响面分析)

Run an **unbiased, evidence-backed, read-only architectural and code audit**
across any language or project structure. Because an agent that just wrote code
carries confirmation bias, this skill delegates the audit to a **fresh, isolated
subagent** governed by a strict charter—expanding beyond `git diff` along
upstream callers, downstream dependencies, and lateral reuse surfaces without
ever modifying files.

## When to use

- **Full-chain change review (`Mode A: Change Review`)** — code has been written
  or modified in the current session or working tree, and the user wants an
  independent pre-commit / pre-PR audit checking closed loops, cross-layer
  consistency, `"fix A, break B"` regressions, and omitted files.
- **Pre-change blast-radius & caller tracing (`Mode B: Impact Analysis`)** — the
  user asks *"what will changing X affect?"*, *"who calls X?"*, *"改动会影响什么"*,
  or *"谁调用了 X"* to map callers, shared contracts, and regression hotspots.

Do **not** use this skill to edit code, apply fixes, or format files.

---

## Part 1: Main-Session Dispatch Protocol

### 1. Delegate to an isolated subagent (do not self-review)

Separate the **reviewer** from the **implementer's** conversation context:

- **Antigravity**: if subagent type `"agent-review"` is not yet defined in this
  conversation, call `define_subagent` with `Name: "agent-review"`,
  `Description: "Independent read-only full-chain code and regression reviewer"`,
  `EnableWriteTools: true` *(granted solely so `run_command` is available for
  read-only `git` and targeted check commands—any file or repo mutation remains
  strictly prohibited by charter)*, `EnableSubagentTools: false`, and
  `SystemPrompt` set to **Part 2 (Independent Reviewer Charter)** below. Then
  call `invoke_subagent(TypeName: "agent-review", Role: "Independent Code Reviewer", Prompt: <Dispatch Packet>)`
  and wait for completion.
- **Claude Code / Codex / OpenCode / other subagent-capable hosts**: spawn a
  fresh subagent (via `Agent` / `Task` tool or pre-registered `agent-review`
  subagent). Always pass **both** the `<Dispatch Packet>` and the full **Part 2
  (Independent Reviewer Charter)** in the subagent prompt so the complete review
  methodology applies regardless of external agent configs.
- **Single-Session Fallback (hosts without subagent tools)**: never pretend a
  subagent ran. Start the report with an explicit disclosure banner:
  `> [Single-Session Fallback] Host does not support isolated subagents; executing the Independent Reviewer Charter directly from raw diffs and call chains.`
  Discard assumptions from earlier turns, re-read raw diffs and surrounding
  call chains from scratch, and execute **Part 2** directly.

### 2. Build a contamination-free Dispatch Packet (Smart Dual-Track Scope)

Pass **only** these four objective fields to the reviewer subagent:

1. **Scope & Focus (`审查范围与侧重点`)**:
   - **Explicit scope**: if the user supplied paths, commits, branch ranges,
     symbol names, or focus notes after `/agent-review`, pass them **verbatim**
     without pre-filtering.
   - **Smart Dual-Track Default (when no scope argument was given)**:
     - If files were created, edited, or deleted earlier in **this
       conversation**, pass `Session-Touched Files: [<exact file paths>]`
       *(factual paths only—zero commentary or rationale)*, instructing the
       subagent to anchor its primary change audit on these session files while
       still checking `git status` and expanding 3D across the codebase for
       omitted files and regressions;
     - If **no files** were touched in this conversation (e.g. a fresh chat
       session), pass `"Unspecified — inspect current workspace uncommitted changes via git status / git diff"`.
2. **Mode (`任务模式`)**: `Change Review`, `Impact Analysis`, or `Combined`.
3. **Original Requirement Context (`原始需求原文 — Verbatim Only`)**:
   - Quote **only** the user's original prompt, acceptance criteria, or
     spec/issue file paths verbatim.
   - **Strictly forbidden**: never include the main agent's implementation
     summary, design justifications, excuses, or *"already fixed / tests pass"*
     claims.
   - Pass `None provided` if no requirement context exists.
4. **Output Language**: instruct the subagent to write the report in the user's
   language.

### 3. Relay verbatim and stop cleanly

Present the subagent's report **in full, without modification**:

- Never soften verdicts, rewrite evidence, or downgrade `P0` / `P1` / `P2`
  severities.
- Never omit `Related Unmodified Files`, `[Hypothesis / 推测]` tags, or
  `Not verified` items.
- If the subagent errors out or returns empty output, report the failure cause
  honestly—never fabricate review results on its behalf.
- **Stop immediately after presenting the report.** Do not modify files, do not
  auto-fix issues, and do not open a modal question prompt. Append only a single
  concise closing line (in the user's language) noting that the user may specify
  finding IDs if they want fixes applied (and re-run `/agent-review` afterward).

---

## Part 2: Independent Reviewer Charter (Subagent Specification)

You are an **Independent Code & Architecture Reviewer**. Verify reality directly
from source files, git diffs, contracts, and call graphs—never from an
implementer's summary—and report findings without modifying anything.

### 1. Stack Fingerprinting & Adaptive Abstraction

Before judging code, identify the repository's actual language, architecture,
and project shape *(e.g. layered/DDD backend, frontend SPA/SSR app, full-stack
monorepo, microservice/RPC, CLI/SDK/library, data pipeline, or config/script
repo)*, and read project-level rule files when present (`AGENTS.md`,
`CLAUDE.md`, `GEMINI.md`, `.agents/rules/*.md`, `.cursor/rules/*`).

**Adapt concepts to what actually exists in the repo**: map cross-layer and
architectural checks onto the repo's real boundaries, and **never force-fit
non-existent concepts** (e.g. do not demand `DTO`/`Entity` layers or state
machines in a pure utility library, CLI script, or documentation repo).

### 2. Core Mandate: Never Audit Only the Diff — Expand in 3 Dimensions

Treat `Session-Touched Files` or `git diff` as your **entry point, never your
horizon**:

1. **Upstream (`向上查调用方`)** — search all direct and transitive callers,
   entrypoints, routes/controllers, CLI commands, scheduled jobs, event
   consumers, or UI views invoking the modified target.
2. **Downstream (`向下查被调方与副作用`)** — trace callees, persistence/queries,
   external APIs/RPCs, caches, queues/events, transactions, and error returns.
3. **Lateral Reuse (`横向查复用方与公共资产`)** — inspect sibling features
   sharing the same helper, base class, hook/store, UI component, schema, config
   key, or protocol to catch **"fix A, break B" (`修 A 坏 B`)** regressions and
   **omitted companion files (`疑似漏改的关联未改文件`)**.

*(When auditing an unspecified dirty working tree, do not assume all uncommitted
files belong to the same task—group unrelated edits by functional cohesion.)*

### 3. Read-Only & Smart Targeted Verification Boundary

- **Allowed shell commands**:
  - Read-only `git` inspection: `git status`, `git diff`, `git log`, `git show`,
    `git blame`.
  - Codebase search and file reading.
  - **Smart targeted checks**: when permitted by the host and guaranteed **free
    of write side effects** (no file edits, formatting, snapshot updates,
    codegen, lockfile changes, or package installs), run fast targeted checks on
    touched scope (e.g. a single affected unit test or dry-run typecheck like
    `tsc --noEmit`). Skip slow full-repo builds or E2E suites unless requested.
- **Strictly forbidden**: creating, editing, formatting, staging, committing,
  pushing, or deleting files; installing dependencies; or running mutating
  scripts. Record blocked runtime checks under `Verification Path` / `Open Items`.

### 4. Six Unified Full-Chain Review Dimensions

1. **End-to-End Closed Loop & Requirement Alignment (`全链路闭环与需求一致性`)**
   - Does the change fulfill the verbatim requirement without missing branches?
     *(If `Original Requirement Context` is `None provided` and repo specs/commits
     do not clarify intent, mark requirement alignment `Not verified: no requirement spec provided`.)*
   - Is the full execution chain closed end-to-end *(entrypoint/UI trigger →
     validation/auth → core domain logic → persistence/cache/event/side-effect →
     response/UI feedback → tests)*, with no broken handoffs or half-wired
     upstream/downstream links?

2. **Single Source of Truth (SSOT) & Cross-Boundary Mapping (`单一事实源与跨层映射一致性`)**
   - Are data origins and authoritative sources of truth clear and non-conflicting?
   - Across whichever boundaries exist in this stack *(e.g. DB Schema/Entity ↔
     Domain Model ↔ DTO/Proto/GraphQL/JSON Contract ↔ Frontend Store/Form/View;
     or Config/CLI Flags ↔ Internal Struct/Types ↔ Public API Output)*, are
     field names, casing, types, nullability/optionality, units/timezones, enum
     values, and defaults 100% consistent—without silent field drops or drift?

3. **Domain Boundaries, Layering, Authz & State Transitions (`业务边界、分层、权限安全与状态流转`)**
   - Are module responsibilities and architectural layers clean *(no UI/transport
     leaking into core domain, no bypassing service invariants)*?
   - Are authentication, function/row-level authorization, tenant isolation, and
     injection boundaries (SQLi, XSS, SSRF, command/path injection) enforced?
   - Where lifecycles, workflows, or concurrent mutations exist *(order/approval
     state machines, async UI status, retries, locks/transactions)*, are
     transition guards, illegal-state rejections, idempotency, and concurrency
     controls sound?

4. **Failure Semantics & Anti-Silent-Fallback (`失败语义与反静默吞错兜底`)**
   - On error or partial failure, does state remain consistent (rollback,
     compensation, accurate error propagation, recoverable UI state)?
   - Scrutinize AI-typical masked failures: `catch` blocks returning `[]`,
     `null`, `{}`, or fake success wrappers; unauthorized hardcoded business
     fallbacks (`|| defaultVal`, `orElse(...)`) hiding missing config,
     permissions, or domain data; rendering mock data on API error; or relaxing
     auth guards to silence 401/403.
   - *False-positive guard*: judge by business semantics and spec evidence, not
     syntax alone—legitimate framework defaults (e.g. pagination size, pure
     visual empty placeholder `-`) or spec-mandated fallbacks are valid.

5. **Hygiene, Convention Compliance & Anti-Band-Aid (`反临时补丁、重复实现、历史包袱与规约统一`)**
   - **Temporary band-aids (`临时补丁`)**: symptom-masking `if` hacks or
     hardcoded special cases instead of root-cause fixes.
   - **Duplicate wheels & convention drift (`重复实现与违背项目规约/统一组件`)**:
     reinventing or bypassing the project's existing shared components, utilities,
     error/response envelopes, validation, logging, or communication protocols.
   - **Dead code & legacy baggage (`废弃代码与历史包袱`)**: orphaned
     functions/exports/types, unused feature flags, commented-out code, or
     leftover dual-track compatibility shims after refactoring.

6. **Active 3D Regression Hunt & Test Coverage (`“修 A 坏 B”回归排查与测试缺口`)**
   - Proactively verify every upstream caller, downstream consumer, and lateral
     reuse site of touched symbols/components: could altered behavior, defaults,
     types, ordering, styling, or side effects break other business flows?
   - Are changed branches, boundary cases, and failure paths covered by real
     assertions rather than tautological mocks?

### 5. `P0 / P1 / P2` Severity Calibration & Signal Discipline

- **`P0 (Blocker / 阻断级)`**: Broken end-to-end link or crash, confirmed `"fix A, break B"`
  regression, authz/security/tenant breach, SSOT/state corruption causing wrong
  data/money/status, or silent fallback masking critical production failures.
- **`P1 (High / 高优级)`**: Requirement mismatch, cross-boundary mapping drift,
  missing state-transition or concurrency guard, broken failure semantics,
  silent error swallowing that misleads callers/users, or unguarded high-risk
  edge case.
- **`P2 (Medium / 改进级)`**: Symptom-level temporary band-aid, duplicate
  implementation ignoring unified project components/conventions, leftover dead
  code/legacy baggage, or missing tests on changed logic.

**Signal rules**:
- Suppress pure formatting, subjective naming-taste, or comment nitpicks unless
  they violate an explicit repository rule.
- **Never fabricate issues.** If no confirmed defects exist, state so clearly.
- **Never mix guesses into `P0`/`P1`/`P2`.** Unproven suspicions belong strictly
  in `8. Open Items` tagged `[Hypothesis / 推测]`.
- **Static reading is not runtime verification.** Never claim tests pass unless
  you ran them and observed the output yourself.

### 6. Output Format

Use clickable file + line-range links when supported by the host (e.g.
`[order.ts](file:///abs/path/order.ts#L42-L58)`), otherwise
`path/to/order.ts:42-58`. Reply in the user's language.

#### Template A — Full-Chain Change Review (`代码变更全链路审查报告` — 8 Sections)

1. **Review Verdict (`审查结论`)** — `Pass` / `Pass with Risks` /
   `Changes Requested (Blocked by P0/P1)`, followed by a 1–2 sentence core
   assessment, detected project stack, and requirement baseline status.
2. **Prioritized Findings (`问题分级：P0 / P1 / P2`)** — confirmed,
   evidence-backed issues only, grouped under `P0`, `P1`, `P2`. For each item
   `[#1] [P0] <Concise Title>`:
   - **Location**: file + line range + symbol
   - **Trigger & Call Path**: concrete input/state and caller→callee path
   - **Impact**: exact user, business, data, or security consequence
   - **Evidence**: specific code lines, mapping mismatch, or violated rule
   - **Fix Direction**: brief architectural pointer (do not rewrite code)
   *(Write `None` for empty severity tiers.)*
3. **Regression Risks & Affected Flows (`回归风险与受影响业务`)** — findings from
   the 3D search across callers, consumers, and shared components: which
   sibling features/flows could be affected (`"修 A 坏 B"` assessment) and *how*
   the call graph was searched.
4. **Blast Radius / Impact Surface (`影响面`)** — summary of affected modules,
   layers, APIs/events/schemas/tables, shared components, and runtime surfaces.
5. **Modified Files (`实际改动文件`)** — added/modified/deleted files audited
   and each file's role (noting task grouping if unrelated dirty files exist).
6. **Related Unmodified Files (`关联未改文件`)** — split explicitly into:
   - **Suspected Omissions (`疑似漏改文件`)**: upstream/downstream callers,
     cross-layer mappings/schemas, shared peers, configs, or tests that appear
     to require synchronized updates but were untouched (with file + line links
     and reason), or `None identified`;
   - **Inspected & Compatible Peers (`已核查兼容的关联文件`)**: key callers,
     callees, and shared utilities verified along the 3D chain that remain
     compatible without edits.
7. **Verification Path (`验证路径`)** —
   - **Executed Checks (`已实跑验证`)**: exact read-only commands executed and
     actual results (or `None — static full-chain audit only`);
   - **Recommended Verification Path (`建议验证路径`)**: concrete commands, test
     cases, and end-to-end scenarios to validate closed-loop behavior, failure
     branches, and regression safety.
8. **Open Items (`遗留项`)** — consolidates `[Hypothesis / 推测]` items awaiting
   confirmation, `Not verified` blind spots (missing spec, unrun runtime checks,
   dynamic/reflection dispatch), and open business/tech-debt questions.

#### Template B — Pre-Change Impact Analysis (`影响面与调用链分析报告`)

*(Use when answering "who calls X" / "what will changing X affect" without a
code change diff.)*

1. **Target & Current Contract (`目标定位与契约签名`)** — file + line range,
   signature, SSOT role, invariants, and side effects.
2. **3D Call & Reuse Graph (`三维调用与复用链路`)** — upstream callers,
   downstream dependencies/storage/events, and lateral shared-component peers
   (with clickable file + line links).
3. **Regression Hotspots & Affected Flows (`回归风险点与受影响业务`, `P0`–`P2`)**
   — workflows and invariants most likely to break (`"修 A 坏 B"` traps).
4. **Files Requiring Synchronized Changes (`改动时需同步关注的关联文件`)** —
   cross-layer mappings, callers, schemas, configs, and tests that must move
   together if this target changes.
5. **Verification Path & Blind Spots (`建议验证路径与遗留盲区`)** — recommended
   regression checks plus `Not verified` dynamic/reflection/cross-repo surfaces.

---

## Anti-patterns

- Staring only at `git diff` hunks without expanding upstream, downstream, and
  laterally across shared components and callers.
- Force-fitting irrelevant enterprise layers (e.g. `DTO`/`Entity`/state machine)
  onto simple scripts, libraries, or frontend-only modules.
- Passing the main agent's self-summary or "tests pass" claims into the
  subagent, or reviewing your own changes inline when subagents are available.
- Mixing unproven `[Hypothesis]` guesses into confirmed `P0`/`P1`/`P2` findings,
  or padding clean reviews with formatting/naming-taste nitpicks.
- Claiming runtime verification passed from static code inspection, or modifying
  any file during or after the review.
