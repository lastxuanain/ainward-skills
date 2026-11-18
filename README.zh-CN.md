# Ainward Skills

[English](README.md) | 简体中文

一套**让 AI 编程助手更可控、更严谨**的开源工程工作流 Skills。

在使用 AI Coding Agent（如 Claude Code、Antigravity、Cursor、Codex 等）写代码时，你是否常遇到这些痛点：**改完一批代码只甩出一长串流水账、总结报喜不报忧、缺乏上下文与调用链核查、未经确认就擅自推进**？

本项目提供一系列开箱即用的工程化工作流技能，遵循开放的 [Agent Skills](https://agentskills.io) 标准，帮你在真实研发场景中把控代码质量、审查改动细节、守住关键决策权。

---

## 可用 Skills

| Skill | 解决什么问题 | 触发方式 | 详细文档 |
|-------|--------------|----------|----------|
| **[work-report](skills/work-report/README.zh-CN.md)**<br>（改动交底） | 告别改完代码后的敷衍流水账与多轮弹窗过堂。用平级大白话**一屏呈报改动与短文件名**，主动坦白`⚠️`妥协与未验证项（不掺入有偏见的自我调用链审查），零弹窗收工并支持按需展开行号或直接修改。 | `/work-report`<br>或自然语言：`向我汇报`、`汇报一下这次改动`、`复盘一下代码` | [查看文档 →](skills/work-report/README.zh-CN.md) |
| **[agent-review](skills/agent-review/README.zh-CN.md)**<br>（独立审查） | 跳出局部 `git diff` 与“自己审自己”偏见。派发**独立只读子 Agent** 沿上游、下游与横向复用链展开全链路审查（支持按改动性质自适应裁剪、纯查“谁调用了 X”秒回），默认输出人话 `Result-First` 结论与短文件行号锚点，发现 `P0/P1` 自动提供一键修复闭环，完整 8 板块按需展开。 | `/agent-review`<br>或自然语言：`审查一下`、`帮我看看这次改动`、`改动会影响什么`、`谁调用了 X` | [查看文档 →](skills/agent-review/README.zh-CN.md) |
| **[code-sync](skills/code-sync/README.zh-CN.md)**<br>（代码同步） | 拒绝无脑 `cherry-pick` 与并行分支串线。严格锁定指令范围实现**双向对话隔离**，只读目标分支最新快照做四象限审计，无冲突时直通按目标最新架构重适配与靶向验证，**Result-First** 呈报效果与短文件名，并自动触发 `agent-review`。 | `/code-sync`<br>或自然语言：`代码同步`、`代码合并`、`同步到分支`、`合并到分支` | [查看文档 →](skills/code-sync/README.zh-CN.md) |
| **[repo-clean](skills/repo-clean/README.zh-CN.md)**<br>（仓库清理） | 专为合并后与多并发开发打造的**低心智负担清理流**。只读快扫仓库与全量关联 `worktree`，后台替读推演文档、Stash 与未合入分支比对是否已落地，自动折叠保护项，输出 **Result-First 双区拍板清单** 并支持回收站与 SHA 后悔药。 | `/repo-clean`<br>或自然语言：`清理仓库`、`清理工作区`、`清理 worktree`、`清理中间产物` | [查看文档 →](skills/repo-clean/README.zh-CN.md) |
| **[modern-web-guidance](skills/modern-web-guidance/README.zh-CN.md)**<br>（上游镜像 · Apache-2.0） | 原样镜像自 [GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance)。在前端任务中通过 `npx -y modern-web-guidance@latest` 引导 Agent 采用现代 HTML / CSS / 客户端 JS 最佳实践。 | 涉及 HTML / CSS / 客户端 JS 任务时自动触发 | [查看文档 →](skills/modern-web-guidance/README.zh-CN.md) |

### 💡 `work-report`（改动交底与走读）核心亮点

当 Agent 完成了多文件修改或一项复杂功能后，对它说一句 **「向我汇报」** 或输入 `/work-report`：

- **一屏全览 + 零弹窗收工**：按功能模块聚合成 `#1..#N` 在同一屏清晰呈现（列出短文件名、默认隐藏 `#L` 行号堆砌），看完即止、不弹连环确认卡；仅当你显式要求「一步一步讲」时才逐项展开。
- **人话坦白妥协与未测项**：直接说明每块「改了什么」，并用 `⚠️` 显眼暴露临时变通、硬编码阈值或隐式假设，实话汇报已跑/未跑验证（不再和 `agent-review` 重叠做自查调用链）。
- **按需展开 + 随口直改**：回复 `展开 #X` 立刻给出可点击代码行号证据；直接下达修改要求则就地修改并靶向验证，零额外清单审批步骤。

👉 **[阅读 `work-report` 完整工作流与使用说明](skills/work-report/README.zh-CN.md)**

### 🔍 `agent-review`（全链路独立代码审查与影响面分析）核心亮点

准备提交代码、发起 PR，或想搞清楚改某个核心模块会波及哪些业务时，输入 `/agent-review`：

- **独立子 Agent + 自适应三维排查**：代码改动坚持派发**零偏见独立只读子 Agent** 沿上游调用方、下游依赖与横向复用排查“修 A 坏 B”（并根据纯文档/样式/逻辑等改动性质自适应裁剪维度）；纯问“谁调用了 X”则在当前会话秒查秒回，不拉重型子 Agent。
- **内严外浅（底层 6 维核查 + 外部 `Result-First`）**：内部严查全链路闭环、跨层契约一致、权限状态、反静默吞错返空与反临时补丁；对外默认呈报人话结论——`Pass` 3 行极简收工，有问题才列 `P0/P1/P2`（附短文件+行号点击锚点），完整 8 板块详表按需回复「展开细节」调出。
- **发现阻断一键闭环 + 串联隔离**：`Pass` 或仅有 `P2` 建议时零弹窗；发现 `P0/P1` 时自动给 1 张单步修复卡（支持一键修完并复核）。被 `code-sync` 串联调用时支持 `Target Workspace`、`Locked Change Scope` 与极简 `Result-First (Chained)` 输出。

👉 **[阅读 `agent-review` 完整工作流与使用说明](skills/agent-review/README.zh-CN.md)**

### 🔀 `code-sync`（语义化代码同步与跨分支合并）核心亮点

在多任务并行开发下，需要将本轮对话修复、工作区未提交改动或源分支提交安全同步到已演进重构的目标分支（如 `main`）时，输入 `/code-sync`：

- **双向并行隔离，严守指令范围**：源端严格硬锁定指定范围（例如“本轮对话改动”只取本会话修改/提交，同分支其他并行提交与无关脏文件静默隔离）；目标端仅读相关文件的**当前最新快照**，绝不泛扫 `main` 上其他并行任务提交，仅在发生真实冲突时才定位冲突并提示。
- **无冲突直奔结果（Smart Fast-Path）与安全隔离落盘**：无分歧/冲突且落盘安全时跳过中间审批弹窗，直接按目标最新架构重适配（需隔离时自动建临时 `git worktree` 而非擅自 `stash`）；仅在出现冲突、同文件脏改撞车或本地落后远端时单步拍板。
- **结果透明 + 合并后自动 `agent-review`**：默认呈报业务效果、**短文件名**与验证状态（隐藏 `#L` 行号与类名堆砌，回复「展开细节」随时查看；若临时 worktree 缺依赖跳测则明说原因并附复跑命令）；落地后自动串联隔离版 `agent-review`，审查 `Pass` 且无临时目录时零弹窗收工，有临时 worktree 时推荐一键 commit 并自动清理。

👉 **[阅读 `code-sync` 完整工作流与使用说明](skills/code-sync/README.zh-CN.md)**

### 🧹 `repo-clean`（低心智负担仓库清理）核心亮点

在完成远程分支合入或并发多 Agent 任务后，直接输入 `/repo-clean` 或说 **「清理工作区」**：

- **仓库核心扫描 + AI 后台替读**：离线只读盘点当前仓库与 `git worktree list` 挂载的全部关联目录，结合 `git cherry` 与语义比对识别 Squash Merge / `code-sync` 已合入分支，并在后台读完未跟踪推演稿与 Stash diff，已落地或已覆盖的直接归入 `🟢 安全清理`。
- **5 秒极简双区视图**：自动折叠 `main`、已跟踪文档与 `CLAUDE.md`/`AGENTS.md` 等保护配置；`🟢` 项只列短名与体积，`🟡` 项附上 AI 总结的**1 句人话内容摘要 + `推荐删/留` 结论**，让你极快拍板。
- **依赖序可逆清理**：先删 worktree 再删对应分支、倒序 drop Stash 防下标错位、未跟踪推演文件优先进**系统回收站**，并在回执附上分支与 Stash 的 **恢复 Commit SHA**（绝不擅自跑销毁 reflog 的 `git gc`）。

👉 **[阅读 `repo-clean` 完整工作流与使用说明](skills/repo-clean/README.zh-CN.md)**

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
# 一条命令安装全部内置 Skills（work-report、agent-review、code-sync、repo-clean、modern-web-guidance）
npx skills add lastxuanain/ainward-skills

# 后续同步远端更新
npx skills update
```

### 方式二：Git 克隆 + 软链接（推荐，后续 `git pull` 即可同步更新）

```bash
# 1. 克隆仓库到本地
git clone https://github.com/lastxuanain/ainward-skills.git ~/ainward-skills
```

然后将需要的 Skill（`work-report`、`agent-review`、`code-sync`、`repo-clean`、`modern-web-guidance`）软链接到你所使用的 Agent 技能目录：

```bash
# Antigravity
mkdir -p ~/.gemini/config/skills
ln -s ~/ainward-skills/skills/work-report ~/.gemini/config/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.gemini/config/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.gemini/config/skills/code-sync
ln -s ~/ainward-skills/skills/repo-clean ~/.gemini/config/skills/repo-clean
ln -s ~/ainward-skills/skills/modern-web-guidance ~/.gemini/config/skills/modern-web-guidance

# Claude Code
mkdir -p ~/.claude/skills
ln -s ~/ainward-skills/skills/work-report ~/.claude/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.claude/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.claude/skills/code-sync
ln -s ~/ainward-skills/skills/repo-clean ~/.claude/skills/repo-clean
ln -s ~/ainward-skills/skills/modern-web-guidance ~/.claude/skills/modern-web-guidance

# Codex
mkdir -p ~/.codex/skills
ln -s ~/ainward-skills/skills/work-report ~/.codex/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.codex/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.codex/skills/code-sync
ln -s ~/ainward-skills/skills/repo-clean ~/.codex/skills/repo-clean
ln -s ~/ainward-skills/skills/modern-web-guidance ~/.codex/skills/modern-web-guidance

# Cursor
mkdir -p ~/.cursor/skills
ln -s ~/ainward-skills/skills/work-report ~/.cursor/skills/work-report
ln -s ~/ainward-skills/skills/agent-review ~/.cursor/skills/agent-review
ln -s ~/ainward-skills/skills/code-sync ~/.cursor/skills/code-sync
ln -s ~/ainward-skills/skills/repo-clean ~/.cursor/skills/repo-clean
ln -s ~/ainward-skills/skills/modern-web-guidance ~/.cursor/skills/modern-web-guidance
```

> **提示**：安装完成后，原创工作流可在对话中输入斜杠命令（`/work-report`、`/agent-review`、`/code-sync`、`/repo-clean`）或自然语言口令（「向我汇报这次改动」「审查一下这次改动」「把改动同步到 main」「清理工作区」）触发；`modern-web-guidance` 则会在处理 HTML / CSS / 客户端 JS 任务时自动触发。
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

- **[MIT](LICENSE)**：适用于本仓库原创工作流 Skills（`work-report`、`agent-review`、`code-sync`、`repo-clean`）及相关仓库文件。
- **第三方上游镜像（`skills/modern-web-guidance/`）**：原样同步自 [GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance)（与本仓库无隶属关系），独立适用上游 **[Apache-2.0 许可证](skills/modern-web-guidance/LICENSE)**（代码）与 **[CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/)**（上游 `guides/` 文档内容，部分衍生自 MDN Web Docs、W3C、WHATWG 与 IETF 规范）。完整归属声明及 `DISABLE_TELEMETRY=1` 遥测退出方式请参见 [skills/modern-web-guidance/README.zh-CN.md](skills/modern-web-guidance/README.zh-CN.md)。
