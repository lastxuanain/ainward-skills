# Ainward Skills

English | [简体中文](README.zh-CN.md)

Open-source engineering workflow skills that make AI coding agents **more controllable, rigorous, and accountable**.

When working with AI coding agents (Claude Code, Antigravity, Cursor, Codex, etc.), it is common to run into frustrating workflows: **one-shot walls of text after large code changes, vague summaries that hide unverified edge cases, missing call-chain impact checks, or agents rushing ahead without confirmation**.

Built on the open [Agent Skills](https://agentskills.io) standard, this repository provides practical, ready-to-use workflows that keep you in control of code quality, review depth, and key engineering decisions.

---

## Available Skills

| Skill | What Problem It Solves | How to Trigger | Docs |
|-------|------------------------|----------------|------|
| **[work-report](skills/work-report/README.md)**<br>(工作汇报) | Replaces passive, one-shot summaries after code changes. The agent briefs you **one logical item at a time** like an engineer reporting to a tech lead, answers interrogations with code evidence, logs your directives, and outputs a consolidated Rectification List (`整改清单`). | `/work-report`<br>or natural language: `"walk me through the changes"`, `"brief me on the changes"`, `"work report"`, `"向我汇报"` | [Read Docs →](skills/work-report/README.md) |
| **[agent-review](skills/agent-review/README.md)**<br>(独立审查) | Goes beyond `git diff` tunnel vision and self-review bias. Delegates **read-only 3D call-graph & full-chain review** to an isolated subagent—catching cross-boundary drift, `"fix A, break B"` regressions, silent fallbacks, and omitted companion files in a `P0/P1/P2` 8-section report. | `/agent-review`<br>or natural language: `"review my changes"`, `"what does this affect"`, `"who calls X"`, `"审查一下"` | [Read Docs →](skills/agent-review/README.md) |
| **[code-sync](skills/code-sync/README.md)**<br>(代码同步) | Replaces blind `cherry-pick` and mechanical copy-pasting across diverged branches. Interactively anchors **source branch, target branch, and sync scope**, runs a zero-checkout 4-state semantic audit (*Already Synced / Superseded / Missing / Conflict*), gates on a Minimal Sync Plan, and re-adapts to the target's current SSOT. | `/code-sync`<br>or natural language: `"code sync"`, `"sync to branch"`, `"semantic merge"`, `"代码同步"`, `"代码合并"` | [Read Docs →](skills/code-sync/README.md) |
| **[modern-web-guidance](skills/modern-web-guidance/README.md)**<br>*(Upstream Mirror · Apache-2.0)* | Unmodified mirror of [GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance). Steers agents toward modern HTML, CSS, and client-side JS patterns via `npx -y modern-web-guidance@latest`. | Auto-triggered on HTML/CSS/client-side JS tasks | [Read Docs →](skills/modern-web-guidance/README.md) |

### 💡 Spotlight: `work-report`

After an agent finishes implementing a feature or modifying multiple files, run `/work-report` or say **"walk me through the changes"**:

- **Executive Snapshot & Paced Walkthrough**: Opens with a high-level snapshot and a `Core / Supporting` tiered agenda, presenting **one item at a time** by default—with one-click **fast-forward batching** whenever you want to breeze through supporting items.
- **5 Evidence Elements + Surfaced Trade-offs**: Every item covers *Scope & Line Links*, *Core Change & Key Trade-offs / Assumptions*, *Upstream/Downstream Call-Chain Impact*, *Honest Verification Status*, and *Progress Tracking*—flagging shortcuts candidly instead of self-rationalizing them.
- **Underailed Q&A & Closed-Loop Sign-Off**: Interrogate choices for on-the-spot code proof or log directives into a numbered **Rectification List (`整改清单`)** without derailing the review; once complete, execute all approved fixes in order and verify via a **Rectification Sign-Off Table**.

👉 **[Read the full `work-report` guide](skills/work-report/README.md)**

### 🔍 Spotlight: `agent-review`

Before committing, opening a PR, or modifying a shared module, run `/agent-review`:

- **Isolated Subagent + 3D Call-Graph Expansion**: Strips away implementer confirmation bias and expands beyond `git diff` across **upstream callers, downstream dependencies, and lateral shared-component reuse** to hunt down `"fix A, break B"` regressions.
- **6 Stack-Adaptive Full-Chain Dimensions**: Auto-fingerprints your repository's real architecture (never force-fitting irrelevant layers) to audit **end-to-end closed loops, single-source-of-truth (SSOT) cross-boundary mappings, authz & state transitions, silent fallbacks, and temporary band-aids / duplicate wheels / dead code**.
- **Structured `P0/P1/P2` 8-Section Engineering Report**: Outputs Review Verdict, Prioritized Findings, Regression Risks & Affected Flows, Blast Radius, Modified Files, **Related Unmodified Files (highlighting suspected omissions)**, Verification Path, and Open Items—stopping cleanly without modifying your files.

👉 **[Read the full `agent-review` guide](skills/agent-review/README.md)**

### 🔀 Spotlight: `code-sync`

When porting a fix or feature from your current session, dirty workspace, or feature/hotfix branch into a refactored target branch (like `main`), run `/code-sync`:

- **Smart Sensing + On-Demand 3-Input Card**: Probes your current branch, dirty files, mounted `git worktree` paths, and cached `origin/*` refs automatically—prompting only for missing inputs across **Session Changes, Workspace Uncommitted Changes, Source Branch Commits, or Specific Commits/Paths**.
- **Zero-Checkout 4-State Semantic Audit**: Inspects the target branch strictly read-only without switching branches, classifying each logical unit as **Already Synced, Superseded by Refactor, Missing/Regressed, or Semantic Conflict**, and drafting a target-native **Minimal Sync Plan (`最小改动清单`)** aligned with current SSOT and 3D call chains.
- **Single-Step Merged Gate + Safe Worktree/Stash Landing**: Consolidates plan approval, conflict choices, and cross-branch landing mode (recommending an isolated temporary `git worktree` when your source tree has uncommitted edits) into a single confirmation turn, closing with targeted verification and a **Sync Sign-Off Table (`同步核销回执表`)**.

👉 **[Read the full `code-sync` guide](skills/code-sync/README.md)**

### 🌐 Mirrored Upstream Skill: `modern-web-guidance` (Third-Party)

Bundled directly so installing `ainward-skills` equips your agent for modern frontend development in one shot:

- **Unmodified Upstream Mirror**: Synced verbatim from [`GoogleChrome/modern-web-guidance`](https://github.com/GoogleChrome/modern-web-guidance) (`SKILL.md` + upstream `LICENSE`; the 250+ `guides/` markdown files are intentionally omitted because `SKILL.md` dynamically retrieves the latest guides via `npx -y modern-web-guidance@latest` at runtime).
- **Automated PR Sync**: Checked daily via [`.github/workflows/sync-modern-web-guidance.yml`](.github/workflows/sync-modern-web-guidance.yml), opening a reviewable Pull Request whenever upstream changes.
- **License & Telemetry**: Independent from this repository's MIT license (governed by **Apache-2.0** / **CC-BY 4.0**; unaffiliated with Google). To opt out of the CLI's anonymous usage telemetry, set `export DISABLE_TELEMETRY=1`.

👉 **[Read the `modern-web-guidance` attribution & telemetry guide](skills/modern-web-guidance/README.md)**

---

## Quick Start & Installation

Each skill is a self-contained directory with a `SKILL.md` file, compatible with any AI coding tool that supports the [Agent Skills](https://agentskills.io) specification.

### Option 1: Install via `npx skills`

```bash
# Install all bundled skills (work-report, agent-review, code-sync, modern-web-guidance) in one command
npx skills add lastxuanain/ainward-skills

# Pull updates later
npx skills update
```

### Option 2: Git Clone + Symlink (Recommended for easy updates via `git pull`)

```bash
# 1. Clone the repository
git clone https://github.com/lastxuanain/ainward-skills.git ~/ainward-skills
```

Then symlink the skills you want (`work-report`, `agent-review`, `code-sync`, `modern-web-guidance`) into your agent's skills directory:

```bash
# Antigravity
mkdir -p ~/.gemini/config/skills
ln -s ~/ainward-skills/skills/work-report ~/.gemini/config/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.gemini/config/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.gemini/config/skills/code-sync
ln -s ~/ainward-skills/skills/modern-web-guidance ~/.gemini/config/skills/modern-web-guidance

# Claude Code
mkdir -p ~/.claude/skills
ln -s ~/ainward-skills/skills/work-report ~/.claude/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.claude/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.claude/skills/code-sync
ln -s ~/ainward-skills/skills/modern-web-guidance ~/.claude/skills/modern-web-guidance

# Codex
mkdir -p ~/.codex/skills
ln -s ~/ainward-skills/skills/work-report ~/.codex/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.codex/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.codex/skills/code-sync
ln -s ~/ainward-skills/skills/modern-web-guidance ~/.codex/skills/modern-web-guidance

# Cursor
mkdir -p ~/.cursor/skills
ln -s ~/ainward-skills/skills/work-report ~/.cursor/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.cursor/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.cursor/skills/code-sync
ln -s ~/ainward-skills/skills/modern-web-guidance ~/.cursor/skills/modern-web-guidance
```

> **Tip**: Once installed, trigger first-party skills directly in chat using slash commands (`/work-report`, `/agent-review`, `/code-sync`) or natural language prompts (`"walk me through the changes"`, `"review my changes"`, `"sync changes to main"`). `modern-web-guidance` triggers automatically on HTML/CSS/client-side JS tasks.
>
> **Tip (Antigravity Plugin users)**: If you already installed Google's official *Modern Web Guidance* plugin from the Antigravity Marketplace, skip symlinking `skills/modern-web-guidance` into `~/.gemini/config/skills/` to avoid loading the same skill twice.

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
├── .github/workflows/
│   └── sync-modern-web-guidance.yml  # Daily upstream PR sync
└── skills/
    ├── <first-party-skill>/
    │   ├── SKILL.md                  # Agent-facing instructions
    │   ├── README.md                 # English documentation
    │   └── README.zh-CN.md           # Chinese documentation
    └── modern-web-guidance/          # Unmodified upstream mirror
        ├── LICENSE                   # Upstream Apache-2.0 license
        ├── SKILL.md                  # Synced from GoogleChrome/modern-web-guidance
        ├── README.md                 # Attribution & telemetry notice (EN)
        └── README.zh-CN.md           # Attribution & telemetry notice (ZH)
```

## License

- **[MIT](LICENSE)** — applies to original `ainward-skills` workflows (`work-report`, `agent-review`, `code-sync`) and repository files.
- **Third-Party Upstream Mirror (`skills/modern-web-guidance/`)** — mirrored unmodified from [GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance) (unaffiliated with `ainward-skills`) and governed by its upstream **[Apache-2.0 License](skills/modern-web-guidance/LICENSE)** (code) and **[CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/)** (upstream `guides/` documentation, with portions derived from MDN Web Docs, W3C, WHATWG, and IETF). See [skills/modern-web-guidance/README.md](skills/modern-web-guidance/README.md) for full attribution and `DISABLE_TELEMETRY=1` opt-out instructions.
