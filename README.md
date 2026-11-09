# Ainward Skills

English | [简体中文](README.zh-CN.md)

Practice-verified AI Agent Skills, maintained under the **Ainward** personal tech brand.

Every skill in this repository is distilled from real engineering workflows and built on the open [Agent Skills](https://agentskills.io) specification for cross-agent reuse.

## Core Principles

| Principle | Meaning |
|-----------|---------|
| **Practice first** | Only skills proven in real engineering tasks are published—nothing written speculatively. |
| **Evidence first** | Skills require agents to back every claim, impact analysis, and verification status with concrete code references and real command output. |
| **Human decision** | Humans stay in control of progression, architectural trade-offs, and irreversible actions (`commit`, `push`, deploy, delete). |
| **Quality first** | High-cohesion workflows over quantity, with explicit maturity status and semantic versioning. |
| **Cross-agent reuse** | Standard `SKILL.md` format with host-agnostic capability descriptions and graceful fallbacks. |

## Skills

| Skill | Categories | Status | Verified on | Summary |
|-------|-----------|--------|-------------|---------|
| [work-report](skills/work-report/README.md) | `agent-workflow`, `engineering-governance`, `software-engineering` | `experimental` | Antigravity | Item-by-item work report and code retrospective: answers leader interrogations with proof, logs directives, and outputs a consolidated Rectification List. |

### Categories

| ID | Category |
|----|----------|
| `software-engineering` | Software engineering and code review |
| `agent-workflow` | AI agent workflows |
| `engineering-governance` | Engineering governance and quality control |
| `research-knowledge` | Technical research and knowledge management |
| `content-creation` | Content creation and production |

### Maturity

| Status | Meaning |
|--------|---------|
| `experimental` | Used in real work and actively being refined. |
| `stable` | Validated across multiple real-world tasks with a settled behavior contract. |
| `deprecated` | Superseded or no longer recommended. |

## Install

Each skill is a self-contained folder with a `SKILL.md`. Clone the repo once, then symlink the skills you need so `git pull` keeps them up to date:

```bash
git clone https://github.com/lastxuanain/ainward-skills.git ~/ainward-skills

# Antigravity (verified)
ln -s ~/ainward-skills/skills/<skill-name> ~/.gemini/config/skills/<skill-name>
```

## Compatibility

| Agent | Status |
|-------|--------|
| Antigravity | ✅ Verified |
| Claude Code, Codex, Gemini CLI, Cursor, and other agents supporting Agent Skills | ⚪ Compatible by spec, not yet verified end-to-end |

## Repository Layout

```text
ainward-skills/
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md         # Agent-facing instructions (English)
│       ├── README.md        # Human-facing documentation (English)
│       └── README.zh-CN.md  # Human-facing documentation (Chinese)
├── README.md
├── README.zh-CN.md
└── LICENSE
```

## License

[MIT](LICENSE) © 2026 Ainward
