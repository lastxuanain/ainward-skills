# modern-web-guidance (Mirrored Upstream Skill)

English | [简体中文](README.zh-CN.md)

> Unmodified mirror of [`skills/modern-web-guidance/SKILL.md`](https://github.com/GoogleChrome/modern-web-guidance/blob/main/skills/modern-web-guidance/SKILL.md) from **[GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance)**, synced so `ainward-skills` users get Modern Web Guidance out of the box with a single install.

## What It Does

Guides AI coding agents to search and retrieve up-to-date HTML, CSS, and client-side JavaScript best practices (e.g., native `<dialog>`, Popover API, CSS Anchor Positioning, Container Queries, View Transitions, Core Web Vitals, accessibility, and safe fallbacks) before writing frontend code.

At runtime, [`SKILL.md`](SKILL.md) invokes the upstream CLI via:

```sh
npx -y modern-web-guidance@latest search "<query>"
npx -y modern-web-guidance@latest retrieve "<id>"
```

## Sync Policy in This Repository

- **Mirrored files**: `SKILL.md` and upstream [`LICENSE`](LICENSE) are copied verbatim from `GoogleChrome/modern-web-guidance` without modification.
- **Excluded `guides/`**: The upstream `guides/` markdown directory is intentionally excluded to keep repository history lightweight, because `SKILL.md` fetches the latest guides dynamically via `npx -y modern-web-guidance@latest`.
- **Automated PR updates**: [`.github/workflows/sync-modern-web-guidance.yml`](../../.github/workflows/sync-modern-web-guidance.yml) checks upstream daily (and supports manual `workflow_dispatch`) and opens a Pull Request for review whenever `skills/modern-web-guidance` changes.
- **Duplicate-plugin tip (Antigravity)**: If you already installed Google's `Modern Web Guidance` plugin from the Antigravity Marketplace, avoid symlinking this directory into `~/.gemini/config/skills/` at the same time so the skill is not loaded twice.

## Attribution, License & Privacy

- **Independent Third-Party Project**: `modern-web-guidance` is stewarded by the Google Chrome, Microsoft Edge, Mozilla Firefox, and MDN teams alongside the web development community. `ainward-skills` is not affiliated with or endorsed by Google.
- **License Separation**: Unlike the original skills in `ainward-skills` (licensed under MIT), files mirrored in this directory retain their upstream licenses:
  - Software/skill code is licensed under the **[Apache License 2.0](LICENSE)** (verbatim copy from upstream).
  - Upstream documentation and guide content (under `guides/` in the upstream repository and retrieved via CLI) are licensed under **[Creative Commons Attribution 4.0 International (CC-BY 4.0)](https://creativecommons.org/licenses/by/4.0/)**, with portions derived from [MDN Web Docs](https://developer.mozilla.org/) by Mozilla Contributors and [W3C](https://www.w3.org/), [WHATWG](https://whatwg.org), and [IETF](https://www.ietf.org) specifications.
  - No modifications were made to the mirrored `SKILL.md` or `LICENSE` files.
- **Telemetry & Opt-Out**: Per the [upstream README](https://github.com/GoogleChrome/modern-web-guidance), the `modern-web-guidance` CLI collects anonymous usage information (installation counts, calling agent name, guide retrieval IDs, and CLI search queries; raw user prompts are not collected). To opt out, add to your shell profile (`.zshrc` / `.bashrc`):
  ```bash
  export DISABLE_TELEMETRY=1
  ```
