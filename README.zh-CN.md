# Ainward Skills

[English](README.md) | 简体中文

经过真实工程实践验证的 AI Agent Skills，以 **Ainward** 个人技术品牌持续沉淀与维护。

本仓库收录的每个 Skill 均提炼自真实研发工作流，遵循开放的 [Agent Skills](https://agentskills.io) 规范，支持跨 Agent 复用。

## 核心原则

| 原则 | 含义 |
|------|------|
| **实践优先** | 只收录在真实任务中实战检验过的 Skill，不凭空设计。 |
| **证据优先** | 要求 Agent 的每项汇报结论、影响面评估与验证结果都附带可核查的代码定位和真实命令输出，禁止猜测与捏造。 |
| **人工决策** | 让开发者始终掌握推进节奏、关键取舍以及不可逆操作（`commit`、`push`、发布、删除等）的决定权。 |
| **质量优先** | 宁少勿滥，明确标注成熟度分级与语义化版本号。 |
| **跨 Agent 复用** | 采用标准 `SKILL.md` 格式，面向通用宿主能力编写指令并提供降级回退方案。 |

## Skill 列表

| Skill | 分类 | 状态 | 已验证 Agent | 简介 |
|-------|------|------|--------------|------|
| [work-report（工作汇报）](skills/work-report/README.zh-CN.md) | `agent-workflow`、`engineering-governance`、`software-engineering` | `experimental` | Antigravity | 面向已改代码的交互式工作汇报与复盘：逐项呈报、响应盘问、记录领导批示并汇总生成《整改清单》。 |

### 分类

| ID | 分类 |
|----|------|
| `software-engineering` | 软件工程与代码审查 |
| `agent-workflow` | AI Agent 工作流 |
| `engineering-governance` | 工程治理与质量控制 |
| `research-knowledge` | 技术研究与知识管理 |
| `content-creation` | 内容创作与生产 |

### 成熟度

| 状态 | 含义 |
|------|------|
| `experimental` | 已在真实工作中使用，仍在持续打磨。 |
| `stable` | 经过多次真实任务检验，行为约定已经稳定。 |
| `deprecated` | 已被替代或不再推荐。 |

## 安装

每个 Skill 都是一个包含 `SKILL.md` 的独立目录。克隆一次仓库，再把需要的 Skill 软链接到宿主目录，之后 `git pull` 即可同步更新：

```bash
git clone https://github.com/lastxuanain/ainward-skills.git ~/ainward-skills

# Antigravity（已验证）
ln -s ~/ainward-skills/skills/<skill-name> ~/.gemini/config/skills/<skill-name>
```

## 兼容性

| Agent | 状态 |
|-------|------|
| Antigravity | ✅ 已验证 |
| Claude Code、Codex、Gemini CLI、Cursor 等支持 Agent Skills 规范的工具 | ⚪ 协议兼容，待实测 |

## 仓库结构

```text
ainward-skills/
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md         # 给 Agent 读的指令（英文）
│       ├── README.md        # 给人读的文档（英文）
│       └── README.zh-CN.md  # 给人读的文档（中文）
├── README.md
├── README.zh-CN.md
└── LICENSE
```

## 许可证

[MIT](LICENSE) © 2026 Ainward
