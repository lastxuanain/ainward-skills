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

### 💡 Spotlight: `work-report`

After an agent finishes implementing a feature or modifying multiple files, run `/work-report` or say **"walk me through the changes"**:

- **Paced Item-by-Item Briefing**: Instead of dumping a massive summary, the agent organizes changes into $N$ logical items and presents **one item at a time**, waiting for your go-ahead at every step.
- **5 Mandatory Evidence Elements**: Every item covers *Scope & Line Links*, *Before/After Logic*, *Upstream/Downstream Call-Chain Impact*, *Honest Verification Status*, and *Progress Tracking*.
- **Interactive Q&A & Actionable Rectification List**: Interrogate specific choices (*"Why change this?"*, *"Will this break caller X?"*) for on-the-spot code proof, or issue directives that get logged into a numbered **Rectification List (`整改清单`)**—ready to execute once the briefing concludes.

👉 **[Read the full `work-report` guide](skills/work-report/README.md)**

### 🔍 Spotlight: `agent-review`

Before committing, opening a PR, or modifying a shared module, run `/agent-review`:

- **Isolated Subagent + 3D Call-Graph Expansion**: Strips away implementer confirmation bias and expands beyond `git diff` across **upstream callers, downstream dependencies, and lateral shared-component reuse** to hunt down `"fix A, break B"` regressions.
- **6 Stack-Adaptive Full-Chain Dimensions**: Auto-fingerprints your repository's real architecture (never force-fitting irrelevant layers) to audit **end-to-end closed loops, single-source-of-truth (SSOT) cross-boundary mappings, authz & state transitions, silent fallbacks, and temporary band-aids / duplicate wheels / dead code**.
- **Structured `P0/P1/P2` 8-Section Engineering Report**: Outputs Review Verdict, Prioritized Findings, Regression Risks & Affected Flows, Blast Radius, Modified Files, **Related Unmodified Files (highlighting suspected omissions)**, Verification Path, and Open Items—stopping cleanly without modifying your files.

👉 **[Read the full `agent-review` guide](skills/agent-review/README.md)**

---

## Quick Start & Installation

Each skill is a self-contained directory with a `SKILL.md` file, compatible with any AI coding tool that supports the [Agent Skills](https://agentskills.io) specification.

### Option 1: Install via `npx skills`

```bash
npx skills add lastxuanain/ainward-skills
```

### Option 2: Git Clone + Symlink (Recommended for easy updates via `git pull`)

```bash
# 1. Clone the repository
git clone https://github.com/lastxuanain/ainward-skills.git ~/ainward-skills
```

Then symlink the skills you want (e.g., `work-report`, `agent-review`) into your agent's skills directory:

```bash
# Antigravity
mkdir -p ~/.gemini/config/skills
ln -s ~/ainward-skills/skills/work-report ~/.gemini/config/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.gemini/config/skills/agent-review

# Claude Code
mkdir -p ~/.claude/skills
ln -s ~/ainward-skills/skills/work-report ~/.claude/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.claude/skills/agent-review

# Codex
mkdir -p ~/.codex/skills
ln -s ~/ainward-skills/skills/work-report ~/.codex/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.codex/skills/agent-review

# Cursor
mkdir -p ~/.cursor/skills
ln -s ~/ainward-skills/skills/work-report ~/.cursor/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.cursor/skills/agent-review
```

> **Tip**: Once installed, trigger the skill directly in chat using its slash command (e.g., `/work-report`, `/agent-review`) or natural language prompt (e.g., `"walk me through the changes"`, `"review my changes"`).

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
└── skills/
    └── <skill-name>/
        ├── SKILL.md         # Agent-facing instructions
        ├── README.md        # English documentation
        └── README.zh-CN.md  # Chinese documentation
```

## License

[MIT](LICENSE)
