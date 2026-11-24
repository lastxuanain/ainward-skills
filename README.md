# Ainward Skills

English | [简体中文](README.zh-CN.md)

Open-source engineering workflow skills that make AI coding agents **more controllable, rigorous, and accountable**.

When working with AI coding agents (Claude Code, Antigravity, Cursor, Codex, etc.), it is common to run into frustrating workflows: **one-shot walls of text after large code changes, vague summaries that hide unverified edge cases, missing call-chain impact checks, or agents rushing ahead without confirmation**.

Built on the open [Agent Skills](https://agentskills.io) standard, this repository provides practical, ready-to-use workflows that keep you in control of code quality, review depth, and key engineering decisions.

---

## Available Skills

| Skill | What Problem It Solves | How to Trigger | Docs |
|-------|------------------------|----------------|------|
| **[plan-review](skills/plan-review/README.md)**<br>(方案评审) | Replaces blind coding, multi-round questionnaire fatigue, and 5-section spec walls. Reads the **real codebase first, plays back the real problem & goal in 2–3 plain sentences** (penetrating XY problems, pushing back candidly), owns secondary trade-offs autonomously, and **converges in 1 turn by default** with a proportional proposal and single sign-off gate (asking only true blocking forks, or stopping zero-popup on restate-only). | `/plan-review`<br>or natural language: `"plan review"`, `"align requirements"`, `"in-your-own-words"`, `"grill-me"`, `"方案评审"`, `"需求纠偏"`, `"复述需求"` | [Read Docs →](skills/plan-review/README.md) |
| **[work-report](skills/work-report/README.md)**<br>(改动交底) | Replaces bloated summaries and multi-turn approval ceremonies. Gives you **one scannable Result-First screen** in plain peer language (with short filenames, `⚠️` trade-offs, and honest test status—no redundant self-reviews or modal popups), expanding `#L` details or applying direct edits on demand. | `/work-report`<br>or natural language: `"walk me through the changes"`, `"brief me on the changes"`, `"work report"`, `"向我汇报"` | [Read Docs →](skills/work-report/README.md) |
| **[agent-review](skills/agent-review/README.md)**<br>(独立审查) | Goes beyond `git diff` tunnel vision and self-review bias. Delegates code audits to an **isolated subagent** across 3D callers, callees, and shared peers (`"fix A, break B"`), delivering **plain-language `Result-First` findings** by default (3-line `Pass`, clickable `file#L` anchors on defects, 1-click `P0/P1` fix loop, 8-section details on demand) plus fast direct `Mode B` caller lookups. | `/agent-review`<br>or natural language: `"review my changes"`, `"what does this affect"`, `"who calls X"`, `"审查一下"` | [Read Docs →](skills/agent-review/README.md) |
| **[code-sync](skills/code-sync/README.md)**<br>(代码同步) | Replaces blind `cherry-pick` and noisy parallel-branch merges. Enforces **bidirectional session isolation** (zero bleed from parallel commits), runs a zero-checkout 4-state audit, fast-paths conflict-free adaptations onto target architecture, delivers **Result-First** outcomes with short filenames, and auto-chains `agent-review`. | `/code-sync`<br>or natural language: `"code sync"`, `"sync to branch"`, `"semantic merge"`, `"代码同步"`, `"代码合并"` | [Read Docs →](skills/code-sync/README.md) |
| **[repo-clean](skills/repo-clean/README.md)**<br>(仓库清理) | Eliminates post-merge and parallel-agent clutter with **minimum cognitive load**. Scans repo + all linked `git worktree` checkouts offline, pre-reads untracked AI plans/stashes/branches against `main`, folds protected assets, and presents a **Result-First** dual-zone cleanup gate with OS Trash + SHA recovery. | `/repo-clean`<br>or natural language: `"repo clean"`, `"clean workspace"`, `"clean worktrees"`, `"清理仓库"`, `"清理工作区"`, `"清理中间产物"` | [Read Docs →](skills/repo-clean/README.md) |
| **[frontend-craft](skills/frontend-craft/README.md)**<br>(前端规范) | Eliminates patchwork routes, AI-slop visuals, and happy-path-only views **100% offline**. Enforces a **Recon-First Gate** (reusing repo tokens, shells, shared UI, and sibling-page conventions), adapts across B2B/SaaS/brand modes, and governs 3-tier tokens, single `DataTable`/modal contracts, React/Vue/Svelte component & 4-way state architecture, CJK-safe 5-state UX, and native HTML/CSS baselines. | Auto-triggered on frontend/UI tasks, or `/frontend-craft`, `"frontend craft"`, `"ui spec"`, `"前端规范"`, `"去 AI 味"` | [Read Docs →](skills/frontend-craft/README.md) |

### 🧭 Spotlight: `plan-review`

Before writing code on a vague requirement, noisy bug thread, or unverified technical direction, run `/plan-review` or say **"review my plan"** / **"align requirements"** / **"in-your-own-words"**:

- **Codebase Facts First & 2–3 Sentence Own-Words Playback**: Reads real source code and repo rules before speaking, then states **what hurts now + what outcome is wanted** in plain words (zero parroting, separating prescribed `Y` from root problem `X`, and pushing back candidly with `file#L` proof when flawed).
- **Proposal-First by Default (Zero Questionnaire Fatigue)**: Owns routine details and clear-winner trade-offs autonomously to **converge in 1 turn on a single screen**—asking an upfront card **only** when a true 50/50 product/contract fork exists (zero strawman options, plus zero-popup stop when restate-only is requested).
- **Proportional Shape + Pre-Code Gate**: Drops rigid 5-section spec boilerplate—small tasks take 6–10 crisp lines of concrete changes and verification (short filenames, zero unsolicited `PLAN*.md` files on disk), pausing on **one** confirmation gate before editing code (named `plan-review` to coexist cleanly with Antigravity's built-in `/grill-me`).

👉 **[Read the full `plan-review` guide](skills/plan-review/README.md)**

### 💡 Spotlight: `work-report`

After an agent finishes implementing a feature or modifying multiple files, run `/work-report` or say **"walk me through the changes"**:

- **One-Screen Digest, Zero Popups**: Groups changes logically on a single screen with **short filenames** (hiding `#L` walls by default) and finishes cleanly without modal click fatigue—switching to step-by-step paging only when you explicitly ask.
- **Candid Trade-offs & Clean Boundary**: Explains what changed in plain language, flags shortcuts/assumptions upfront with `⚠️`, and reports real test status—leaving independent regression hunting cleanly to `agent-review`.
- **On-Demand Drill-Down & Direct Edits**: Reply `"expand #X"` for clickable code line proof, or state adjustments directly in chat to have them applied and verified immediately.

👉 **[Read the full `work-report` guide](skills/work-report/README.md)**

### 🔍 Spotlight: `agent-review`

Before committing, opening a PR, or modifying a shared module, run `/agent-review`:

- **Isolated Subagent + Adaptive 3D Tracing**: Code changes always run in a **zero-bias isolated read-only subagent** tracing upstream callers, downstream side effects, and lateral shared peers (`"fix A, break B"`), scaling depth by change risk; pure `"who calls X"` queries answer fast and directly in the current session.
- **Strict Inside, Plain `Result-First` Outside**: Audits closed loops, cross-boundary contracts, authz/state safety, silent fallbacks, and band-aids internally—while delivering a 3-line `Pass` when clean, or plain-language `P0/P1/P2` defects with clickable `file#L` anchors (with full 8-section inventories available on `"show details"`).
- **1-Click `P0/P1` Closure + Caller Isolation**: Stops with zero popups on `Pass` or `P2`-only runs, and pops a single fix-and-reverify card when `P0`/`P1` blockers appear. Also supports `Target Workspace`, `Locked Change Scope`, and `Result-First (Chained)` for [`code-sync`](skills/code-sync/README.md).

👉 **[Read the full `agent-review` guide](skills/agent-review/README.md)**

### 🔀 Spotlight: `code-sync`

When porting a fix or feature from your current session, dirty workspace, or feature/hotfix branch into a refactored or busy target branch (like `main`), run `/code-sync`:

- **Strict Bidirectional Parallel Isolation**: Locks strictly to the requested scope (e.g., **Session Changes only**—silently ignoring other commits or dirty files on the same branch) and reads only the **current target snapshot** without scanning unrelated parallel commit history on `main` unless a direct conflict occurs.
- **Smart Fast-Path + Safe Worktree Landing**: Skips redundant pre-execution checklist popups when conflict-free—adapting straight to target architecture (using a sibling `git worktree` when needed without touching your source tree or running unprompted `git stash`), pausing only on genuine conflicts, parallel dirty clashes, or stale local target refs.
- **Transparent Outcomes + Auto `agent-review`**: Presents clean functional outcomes alongside **short target filenames** (hiding `#L` line dumps until `"show details"`, and explaining skipped temp-worktree tests in 1 plain sentence with the command to re-run on `<target>`), chains isolated `agent-review`, and finishes cleanly with zero popups when clean—or defaults `(Recommended)` to committing and auto-cleaning temporary worktrees on `Pass`.

👉 **[Read the full `code-sync` guide](skills/code-sync/README.md)**

### 🧹 Spotlight: `repo-clean`

After merging remote branches or finishing parallel multi-agent tasks, run `/repo-clean` or say **"clean workspace"**:

- **Repo-Centric Scan + AI Pre-Digestion**: Audits the active repo and all linked `git worktree list` checkouts offline—detecting squash-merged / `code-sync` branches (`git cherry` + semantic checks), applied stashes, and untracked `PLAN*`/`ANALYSIS*` docs whose changes already landed in `main`.
- **5-Second Result-First Dual-Zone Gate**: Auto-folds protected assets (`main`, tracked docs, `CLAUDE.md`/`AGENTS.md`), lists settled `🟢` cleanups compactly, and writes a **1-line plain-language summary + `Keep / Delete` lean** for any remaining `🟡` items.
- **Dependency-Safe Recoverable Execution**: Removes worktrees before their branches, drops stashes in descending index order, sends untracked plan docs to **OS Trash**, and prints **recovery Commit SHAs** for deleted branches and stashes without running destructive `git gc`.

👉 **[Read the full `repo-clean` guide](skills/repo-clean/README.md)**

### 🎨 Spotlight: `frontend-craft`

Whenever building, refactoring, styling, or auditing web UI—automatically on frontend tasks or explicitly via `/frontend-craft`:

- **Recon-First Gate + Product Mode Routing**: Inspects existing theme tokens, layout shells, shared components, and 1 sibling page before touching UI (extending shared primitives rather than inventing page-specific patchwork), while adapting density across **B2B Admin Ledgers**, **Interactive SaaS Workbenches**, and **Brand / Consumer Apps**.
- **Cross-Page Consistency & Anti-AI-Slop Visuals**: Locks a 3-tier token chain (`Primitive → Semantic → Component` + `@layer`), 4 standard page archetypes, a single `DataTable` contract (`—` empty cells, right-aligned `tabular-nums`, sticky actions folding `> 3` items into `⋯`), and strict red lines against purple neon gradients, glowing card clutter, badge spam, and Emoji icons.
- **5-State UX, Clean Architecture & Offline Native Baseline**: Loads modular `references/01..05` on demand—enforcing `Loading / Empty / Error / Overflow / Pending` views, blur-delayed form errors, `!event.isComposing` CJK IME Enter safety, 3-layer React/Vue/Svelte boundaries + 4-way state taxonomy, and `<dialog>` / `popover` / `@container` / `100dvh` / `:has()` / `color-mix()` baselines (coexisting cleanly alongside browser-API lookup plugins).

👉 **[Read the full `frontend-craft` guide](skills/frontend-craft/README.md)**

---

## Quick Start & Installation

Each skill is a self-contained directory with a `SKILL.md` file, compatible with any AI coding tool that supports the [Agent Skills](https://agentskills.io) specification.

### Option 1: Install via `npx skills`

```bash
# Install all bundled skills (plan-review, work-report, agent-review, code-sync, repo-clean, frontend-craft) in one command
npx skills add lastxuanain/ainward-skills

# Pull updates later
npx skills update
```

### Option 2: Git Clone + Symlink (Recommended for easy updates via `git pull`)

```bash
# 1. Clone the repository
git clone https://github.com/lastxuanain/ainward-skills.git ~/ainward-skills

# 2. One-command symlink sync across auto-detected local agents (Antigravity, Claude Code, Codex, OpenCode, Cursor)
~/ainward-skills/scripts/link.sh
```

Or symlink individual skills (`plan-review`, `work-report`, `agent-review`, `code-sync`, `repo-clean`, `frontend-craft`) manually into your agent's skills directory:

```bash
# Antigravity
mkdir -p ~/.gemini/config/skills
ln -s ~/ainward-skills/skills/plan-review ~/.gemini/config/skills/plan-review
ln -s ~/ainward-skills/skills/work-report ~/.gemini/config/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.gemini/config/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.gemini/config/skills/code-sync
ln -s ~/ainward-skills/skills/repo-clean ~/.gemini/config/skills/repo-clean
ln -s ~/ainward-skills/skills/frontend-craft ~/.gemini/config/skills/frontend-craft

# Claude Code
mkdir -p ~/.claude/skills
ln -s ~/ainward-skills/skills/plan-review ~/.claude/skills/plan-review
ln -s ~/ainward-skills/skills/work-report ~/.claude/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.claude/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.claude/skills/code-sync
ln -s ~/ainward-skills/skills/repo-clean ~/.claude/skills/repo-clean
ln -s ~/ainward-skills/skills/frontend-craft ~/.claude/skills/frontend-craft

# Codex
mkdir -p ~/.codex/skills
ln -s ~/ainward-skills/skills/plan-review ~/.codex/skills/plan-review
ln -s ~/ainward-skills/skills/work-report ~/.codex/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.codex/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.codex/skills/code-sync
ln -s ~/ainward-skills/skills/repo-clean ~/.codex/skills/repo-clean
ln -s ~/ainward-skills/skills/frontend-craft ~/.codex/skills/frontend-craft

# Cursor
mkdir -p ~/.cursor/skills
ln -s ~/ainward-skills/skills/plan-review ~/.cursor/skills/plan-review
ln -s ~/ainward-skills/skills/work-report ~/.cursor/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.cursor/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.cursor/skills/code-sync
ln -s ~/ainward-skills/skills/repo-clean ~/.cursor/skills/repo-clean
ln -s ~/ainward-skills/skills/frontend-craft ~/.cursor/skills/frontend-craft
```

> **Tip**: Trigger workflow skills directly in chat via slash commands (`/plan-review`, `/work-report`, `/agent-review`, `/code-sync`, `/repo-clean`, `/frontend-craft`) or natural language prompts (`"review my plan"`, `"walk me through the changes"`, `"review my changes"`, `"sync changes to main"`, `"clean workspace"`). `frontend-craft` also triggers automatically on frontend UI tasks and coexists without name collisions alongside official browser-API lookup plugins such as *Modern Web Guidance*.

---

## Why Use These Skills?

- **Evidence Over Guesswork**: Agents are required to back every claim, call-chain impact analysis, and verification status with concrete file/line references and real command output—explicitly marking unrun checks as `Not verified` rather than fabricating success.
- **Human-in-the-Loop Control**: Built-in confirmation gates keep you in charge of pacing, architectural trade-offs, and any irreversible actions (`commit`, `push`, or follow-up edits).
- **Battle-Tested in Real Workflows**: Every skill is distilled from recurring pain points in daily software engineering—focused on high-utility workflows rather than quantity.
- **Cross-Agent Portability**: Written in the standard `SKILL.md` format with graceful fallbacks so your workflows stay consistent across different AI coding agents.

---

## Contributing & Feedback

Feedback, bug reports, and pull requests are welcome! Feel free to open an [Issue](https://github.com/lastxuanain/ainward-skills/issues) to suggest improvements or propose new engineering skills.

Repository structure:

```text
ainward-skills/
├── scripts/
│   └── link.sh                       # Local multi-agent symlink manager
└── skills/
    └── <skill-name>/
        ├── SKILL.md                  # Agent-facing core instructions & router
        ├── references/               # Optional progressive-disclosure specs
        ├── README.md                 # English documentation
        └── README.zh-CN.md           # Chinese documentation
```

## License

Released under the **[MIT License](LICENSE)**.
