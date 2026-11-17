# modern-web-guidance（上游镜像收录）

[English](README.md) | 简体中文

> 本目录原样镜像同步自 **[GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance)** 的 [`skills/modern-web-guidance/SKILL.md`](https://github.com/GoogleChrome/modern-web-guidance/blob/main/skills/modern-web-guidance/SKILL.md)，让用户只需安装 `ainward-skills` 即可开箱使用 Modern Web Guidance。

## 功能简介

在编写或修改前端页面、CSS 布局/动效或客户端 JS 时，引导 Agent 优先查询并遵循现代 Web 平台最佳实践（如原生 `<dialog>`、Popover API、CSS Anchor Positioning、Container Queries、View Transitions、Core Web Vitals、无障碍访问与轻量降级方案），避免回退到过时写法。

[`SKILL.md`](SKILL.md) 在运行时通过上游 CLI 动态检索指南：

```sh
npx -y modern-web-guidance@latest search "<query>"
npx -y modern-web-guidance@latest retrieve "<id>"
```

## 本仓库同步策略

- **镜像文件**：本目录下的 `SKILL.md` 与上游 [`LICENSE`](LICENSE) 均原样同步自 `GoogleChrome/modern-web-guidance`，未做任何内容改写。
- **排除 `guides/` 目录**：由于 `SKILL.md` 运行时会自动通过 `npx -y modern-web-guidance@latest` 拉取最新指南，本仓库特意不镜像上游 250+ 篇 `guides/` 文档，以保持仓库轻量与提交历史干净。
- **自动巡检提 PR**：通过 [`.github/workflows/sync-modern-web-guidance.yml`](../../.github/workflows/sync-modern-web-guidance.yml) 每日定时检查上游更新（也支持手动 `workflow_dispatch`），有变更时自动创建/更新 PR 经人工确认后合入。
- **本地防重复提示（Antigravity）**：如果你本机已经通过 Antigravity 插件市场安装了官方 `Modern Web Guidance` 插件，则无需再把本目录软链接到 `~/.gemini/config/skills/`，避免同一技能被重复加载。

## 版权归属、许可证与隐私说明

- **独立第三方项目**：`modern-web-guidance` 由 Google Chrome、Microsoft Edge、Mozilla Firefox 与 MDN 团队及社区共同维护，与 `ainward-skills` 无任何隶属或官方背书关系。
- **协议隔离边界**：本仓库原创技能适用根目录 MIT 协议；本目录镜像自上游的文件独立适用其原协议：
  - 代码与技能脚本适用 **[Apache License 2.0](LICENSE)**（完整保留上游 `LICENSE` 文件）。
  - 上游 `guides/` 文档及 CLI 检索返回的指南内容适用 **[Creative Commons Attribution 4.0 International (CC-BY 4.0)](https://creativecommons.org/licenses/by/4.0/)**，其中部分内容衍生自 [MDN Web Docs](https://developer.mozilla.org/)（Mozilla Contributors）及 [W3C](https://www.w3.org/)、[WHATWG](https://whatwg.org)、[IETF](https://www.ietf.org) 规范。
  - 本仓库未对镜像的 `SKILL.md` 与 `LICENSE` 做修改。
- **匿名遥测退出提示**：根据[上游仓库 README](https://github.com/GoogleChrome/modern-web-guidance)，`modern-web-guidance` CLI 默认会上报匿名使用信息（包含安装计数、调用 Agent 名称、指南检索 ID 及 CLI 搜索关键词，不收集原始用户提示词）。如需关闭，可在 `.zshrc` / `.bashrc` 中添加：
  ```bash
  export DISABLE_TELEMETRY=1
  ```
