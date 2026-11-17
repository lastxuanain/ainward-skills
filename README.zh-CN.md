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
| **[code-sync](skills/code-sync/README.zh-CN.md)**<br>（代码同步） | 拒绝无脑 `cherry-pick` 与机械复制旧代码。交互式锚定**源分支、目标分支与合并范围**，零切分支提取真实语义并做四类状态盘点（已同步 / 被重构覆盖 / 缺失回归 / 语义冲突），经《最小改动清单》门禁后按目标架构安全重适配。 | `/code-sync`<br>或自然语言：`代码同步`、`代码合并`、`同步到分支`、`合并到分支` | [查看文档 →](skills/code-sync/README.zh-CN.md) |
| **[modern-web-guidance](skills/modern-web-guidance/README.zh-CN.md)**<br>（上游镜像 · Apache-2.0） | 原样镜像自 [GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance)。在前端任务中通过 `npx -y modern-web-guidance@latest` 引导 Agent 采用现代 HTML / CSS / 客户端 JS 最佳实践。 | 涉及 HTML / CSS / 客户端 JS 任务时自动触发 | [查看文档 →](skills/modern-web-guidance/README.zh-CN.md) |

### 💡 `work-report`（工作汇报）核心亮点

当 Agent 完成了多文件修改或一项复杂功能后，对它说一句 **「向我汇报」** 或输入 `/work-report`：

- **全局总括 + 分层节奏过堂**：先给全局完成度总括与 `核心 / 配套` 分层提纲，默认每次汇报 **1 项**，同时支持一键**快进合并汇报剩余配套项**或随时点名跳项，既掌控核心又不拖沓。
- **固定五要素 + 主动暴露取舍**：每项汇报覆盖「改动定位（带可点击行号）」「核心变更逻辑与**设计取舍/隐式假设**」「上下游调用链影响面」「真实自测情况」「当前进度」，拒绝把临时补丁包装成完美方案。
- **盘问不脱轨，按单核销闭环**：随时追问细节拿代码证据作答；下达的修改意见记入《整改清单》不打断汇报主线，最后统一汇总、一键按单整改并输出《整改核销回执表》。

👉 **[阅读 `work-report` 完整工作流与使用说明](skills/work-report/README.zh-CN.md)**

### 🔍 `agent-review`（全链路独立代码审查与影响面分析）核心亮点

准备提交代码、发起 PR，或想搞清楚改某个核心模块会波及哪些业务时，输入 `/agent-review`：

- **独立子 Agent + 三维全链路展开**：剥离实现者自评滤镜，不只看 `git diff`，主动沿**上游调用方、下游依赖、横向公共复用组件**立体检索，严查“修 A 坏 B”回归风险。
- **跨语言自适应 6 大审查内核**：自动识别项目技术栈与真实分层（不生搬硬套不存在的概念），核查**全链路闭环、单一事实源（SSOT）跨层映射一致性、权限与状态流转、反静默吞错兜底、反临时补丁/重复造轮子/废弃死代码**。
- **`P0/P1/P2` 八板块工程报告**：固定输出审查结论、问题分级、回归风险与受影响业务、影响面、实际改动文件、**关联未改文件（含疑似漏改预警）**、验证路径与遗留项，只报证据、交卷即停、绝不擅改代码。

👉 **[阅读 `agent-review` 完整工作流与使用说明](skills/agent-review/README.zh-CN.md)**

### 🔀 `code-sync`（语义化代码同步与跨分支合并）核心亮点

需要将本轮对话修复、工作区未提交改动或源分支提交同步到已演进重构的目标分支（如 `main`）时，输入 `/code-sync`：

- **智能预检 + 单轮按需锚定三要素**：自动探测当前分支、会话/工作区脏状态、挂载 `worktree` 与 `origin` 缓存引用，仅对未指明项在单张卡片中推荐补全（支持**本次对话改动 / 工作区改动 / 源分支领先提交 / 指定 Commit 或文件**）。
- **零切分支四象限盘点，拒绝机械复制**：分析期不切分支、不乱碰现场，基于真实修复意图将改动归类为**已同步、已被后续重构覆盖、仍缺失或有回归、存在语义分歧**，按目标分支当前架构与事实源（SSOT）设计《最小改动清单》。
- **单步合并门禁 + Worktree/Stash 安全隔离落地**：在一次确认中合并完成清单拍板、分歧决策与跨分支写入方式（源分支有未提交改动时默认推荐独立临时 `git worktree` 隔离写），靶向验证后输出《同步核销回执表》。

👉 **[阅读 `code-sync` 完整工作流与使用说明](skills/code-sync/README.zh-CN.md)**

### 🌐 同步收录的第三方 Skill：`modern-web-guidance`

直接内置于仓库中，安装 `ainward-skills` 即可一站式获得现代 Web 开发规范指引：

- **上游原样镜像**：原样同步自 [`GoogleChrome/modern-web-guidance`](https://github.com/GoogleChrome/modern-web-guidance)（仅包含 `SKILL.md` 与上游 `LICENSE`；由于 `SKILL.md` 运行时会通过 `npx -y modern-web-guidance@latest` 动态拉取最新指南，故意排除了 250+ 篇 `guides/` 文档以保持仓库轻量）。
- **自动巡检提 PR**：由 [`.github/workflows/sync-modern-web-guidance.yml`](.github/workflows/sync-modern-web-guidance.yml) 每日检查上游变更并自动创建 PR，人工确认后合入。
- **独立协议与遥测**：独立于本仓库的 MIT 协议，沿用上游 **Apache-2.0 / CC-BY 4.0** 协议（与谷歌无隶属关系）；如需关闭其 CLI 匿名遥测，可设置 `export DISABLE_TELEMETRY=1`。

👉 **[阅读 `modern-web-guidance` 版权归属与遥测说明](skills/modern-web-guidance/README.zh-CN.md)**

---

## 快速安装与使用

每个 Skill 都是一个包含 `SKILL.md` 的独立目录，兼容所有支持 [Agent Skills](https://agentskills.io) 规范的 AI 编程工具。

### 方式一：使用 `npx skills` 一键安装

```bash
# 一条命令安装全部内置 Skills（work-report、agent-review、code-sync、modern-web-guidance）
npx skills add lastxuanain/ainward-skills

# 后续同步远端更新
npx skills update
```

### 方式二：Git 克隆 + 软链接（推荐，后续 `git pull` 即可同步更新）

```bash
# 1. 克隆仓库到本地
git clone https://github.com/lastxuanain/ainward-skills.git ~/ainward-skills
```

然后将需要的 Skill（`work-report`、`agent-review`、`code-sync`、`modern-web-guidance`）软链接到你所使用的 Agent 技能目录：

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

> **提示**：安装完成后，原创工作流可在对话中输入斜杠命令（`/work-report`、`/agent-review`、`/code-sync`）或自然语言口令（「向我汇报这次改动」「审查一下这次改动」「把改动同步到 main」）触发；`modern-web-guidance` 则会在处理 HTML / CSS / 客户端 JS 任务时自动触发。
>
> **提示（Antigravity 插件用户）**：如果你已通过 Antigravity 插件市场安装了官方 *Modern Web Guidance* 插件，可跳过将 `skills/modern-web-guidance` 软链接到 `~/.gemini/config/skills/`，避免同一技能被重复加载。

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
├── .github/workflows/
│   └── sync-modern-web-guidance.yml  # 每日自动检查上游并提 PR
└── skills/
    ├── <first-party-skill>/
    │   ├── SKILL.md                  # 给 Agent 读取的核心指令
    │   ├── README.md                 # 英文使用说明
    │   └── README.zh-CN.md           # 中文使用说明
    └── modern-web-guidance/          # 上游原样镜像收录
        ├── LICENSE                   # 上游 Apache-2.0 许可证
        ├── SKILL.md                  # 同步自 GoogleChrome/modern-web-guidance
        ├── README.md                 # 版权归属与遥测说明（英文）
        └── README.zh-CN.md           # 版权归属与遥测说明（中文）
```

## 许可证

- **[MIT](LICENSE)**：适用于本仓库原创工作流 Skills（`work-report`、`agent-review`、`code-sync`）及相关仓库文件。
- **第三方上游镜像（`skills/modern-web-guidance/`）**：原样同步自 [GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance)（与本仓库无隶属关系），独立适用上游 **[Apache-2.0 许可证](skills/modern-web-guidance/LICENSE)**（代码）与 **[CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/)**（上游 `guides/` 文档内容，部分衍生自 MDN Web Docs、W3C、WHATWG 与 IETF 规范）。完整归属声明及 `DISABLE_TELEMETRY=1` 遥测退出方式请参见 [skills/modern-web-guidance/README.zh-CN.md](skills/modern-web-guidance/README.zh-CN.md)。
