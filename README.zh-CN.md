# Ainward Skills

[English](README.md) | 简体中文

一套**让 AI 编程助手更可控、更严谨**的开源工程工作流 Skills。

在使用 AI Coding Agent（如 Claude Code、Antigravity、Cursor、Codex 等）写代码时，你是否常遇到这些痛点：**改完一批代码只甩出一长串流水账、总结报喜不报忧、缺乏上下文与调用链核查、未经确认就擅自推进**？

本项目提供一系列开箱即用的工程化工作流技能，遵循开放的 [Agent Skills](https://agentskills.io) 标准，帮你在真实研发场景中把控代码质量、审查改动细节、守住关键决策权。

---

## 可用 Skills

| Skill | 解决什么问题 | 触发方式 | 详细文档 |
|-------|--------------|----------|----------|
| **[work-report](skills/work-report/README.zh-CN.md)**<br>（工作汇报） | 告别改完代码后的敷衍流水账总结。让 Agent 像下属向技术负责人汇报一样**逐项呈报改动、接受细节盘问、记录修改批示**，最后输出《整改清单》。 | `/work-report`<br>或自然语言：`向我汇报`、`逐项汇报`、`汇报一下这次改动`、`复盘一下代码` | [查看文档 →](skills/work-report/README.zh-CN.md) |
| **[agent-review](skills/agent-review/README.zh-CN.md)**<br>（独立审查） | 跳出局部 `git diff` 与“自己审自己”偏见。派发**独立只读子 Agent** 沿上游、下游与横向复用链展开全链路审查，排查跨层映射、“修 A 坏 B”回归与关联漏改文件，输出 `P0/P1/P2` 八板块报告。 | `/agent-review`<br>或自然语言：`审查一下`、`帮我看看这次改动`、`改动会影响什么`、`谁调用了 X` | [查看文档 →](skills/agent-review/README.zh-CN.md) |

### 💡 `work-report`（工作汇报）核心亮点

当 Agent 完成了多文件修改或一项复杂功能后，对它说一句 **「向我汇报」** 或输入 `/work-report`：

- **拒绝刷屏，逐项过堂**：先梳理 $N$ 项汇报提纲，每次只汇报 **1 项**，由你掌控节奏（听下一项 / 追问细节 / 下达整改批示）。
- **固定五要素，有据可查**：每项必须汇报「改动定位（带可点击行号）」「核心变更逻辑」「上下游调用链影响面」「真实自测情况」「当前进度」。
- **盘问与批示不脱轨**：你可以随时质问“为什么这么改？”“会不会影响其他调用方？”，Agent 会现场查证代码作答；你下达的修改意见会被记入《整改清单》，待全部汇报结束后统一汇总并请示是否立即执行。

👉 **[阅读 `work-report` 完整工作流与使用说明](skills/work-report/README.zh-CN.md)**

### 🔍 `agent-review`（全链路独立代码审查与影响面分析）核心亮点

准备提交代码、发起 PR，或想搞清楚改某个核心模块会波及哪些业务时，输入 `/agent-review`：

- **独立子 Agent + 三维全链路展开**：剥离实现者自评滤镜，不只看 `git diff`，主动沿**上游调用方、下游依赖、横向公共复用组件**立体检索，严查“修 A 坏 B”回归风险。
- **跨语言自适应 6 大审查内核**：自动识别项目技术栈与真实分层（不生搬硬套不存在的概念），核查**全链路闭环、单一事实源（SSOT）跨层映射一致性、权限与状态流转、反静默吞错兜底、反临时补丁/重复造轮子/废弃死代码**。
- **`P0/P1/P2` 八板块工程报告**：固定输出审查结论、问题分级、回归风险与受影响业务、影响面、实际改动文件、**关联未改文件（含疑似漏改预警）**、验证路径与遗留项，只报证据、交卷即停、绝不擅改代码。

👉 **[阅读 `agent-review` 完整工作流与使用说明](skills/agent-review/README.zh-CN.md)**

---

## 快速安装与使用

每个 Skill 都是一个包含 `SKILL.md` 的独立目录，兼容所有支持 [Agent Skills](https://agentskills.io) 规范的 AI 编程工具。

### 方式一：使用 `npx skills` 一键安装

```bash
npx skills add lastxuanain/ainward-skills
```

### 方式二：Git 克隆 + 软链接（推荐，后续 `git pull` 即可同步更新）

```bash
# 1. 克隆仓库到本地
git clone https://github.com/lastxuanain/ainward-skills.git ~/ainward-skills
```

然后将需要的 Skill（如 `work-report`、`agent-review`）软链接到你所使用的 Agent 技能目录：

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

> **提示**：安装完成后，在对话中直接输入对应的斜杠命令（如 `/work-report`、`/agent-review`）或自然语言口令（如「向我汇报这次改动」「审查一下这次改动」）即可触发。

---

## 为什么使用这套 Skills？

- **拿代码证据说话，杜绝盲猜与瞒报**：要求 Agent 的每项结论、调用链影响评估和验证状态都必须附带真实代码定位与实际运行结果；没跑过的测试坦诚标记为 `Not verified`，绝不捏造“全部通过”。
- **把控节奏，人类掌握最终决策权**：通过明确的交互门禁（Gate），让开发者始终掌控推进节奏、架构取舍以及任何不可逆操作（如修改执行、`commit`、`push` 等）。
- **源自真实工程实战**：只收录在日常研发高频场景中反复验证、真正能提升人机协作体验的工作流，宁缺毋滥。
- **跨工具开放兼容**：采用标准 `SKILL.md` 规范编写，并提供通用能力降级回退方案，切换不同 Agent 工具也能保持一致的协作体验。

---

## 参与贡献与反馈

欢迎通过 [Issues](https://github.com/lastxuanain/ainward-skills/issues) 反馈使用体验、提出改进建议，或通过 Pull Request 贡献新的工程工作流 Skill！

仓库采用简洁直观的目录结构，方便查阅与扩展：

```text
ainward-skills/
└── skills/
    └── <skill-name>/
        ├── SKILL.md         # 给 Agent 读取的核心指令
        ├── README.md        # 英文使用说明
        └── README.zh-CN.md  # 中文使用说明
```

## 许可证

[MIT](LICENSE)
