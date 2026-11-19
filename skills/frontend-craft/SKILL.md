---
name: frontend-craft
description: >-
  Self-contained, offline frontend design, cross-page consistency, and
  component/state engineering specification. Enforces a Recon-First Gate on
  existing repos (reusing tokens, shells, shared components, and sibling-page
  conventions before coding), adapts visual density across B2B admin, SaaS
  workbench, and brand/consumer archetypes, eliminates AI-slop aesthetics, and
  mandates 5-state async completeness, clean React/Vue/Svelte component & state
  boundaries, CJK-safe forms, and modern native HTML/CSS baselines.
  Auto-trigger on: building, refactoring, styling, or reviewing web UI pages,
  components, layouts, tables, forms, modals, design tokens, CSS, or client-side
  state. Explicit triggers: /frontend-craft, "frontend craft", "ui spec",
  "frontend guide", "design system audit", "anti ai slop", "前端规范", "UI 规范",
  "前端视觉规范", "前端架构规范", "去 AI 味".
  DO NOT trigger for: pure backend logic (SQL, ORMs, server-only APIs), CLI/infra
  scripts (Docker, CI/CD, Git), or non-UI build/test configuration bumps.
license: MIT
compatibility: >-
  100% offline, self-contained Markdown skill (zero external CLI or network
  calls). Agnostic across React, Next.js, Vue, Nuxt, Svelte, Astro, Tailwind CSS,
  CSS Modules, and vanilla HTML/CSS/TypeScript; coexists cleanly alongside
  browser-API lookup plugins.
metadata:
  author: Ainward
  version: "1.0.0"
  status: experimental
  category: "frontend-architecture, ui-design-system, ux-engineering, web-standards"
  verified-agents: "antigravity"
---

# Frontend Craft (前端视觉、一致性与工程架构规范)

Build **cohesive, production-grade web interfaces** that look intentionally
designed, stay structurally consistent across every route in a repository, and
remain maintainable as component and state complexity grows—without external CLI
lookups, ad-hoc page patchwork, or generic AI visual clichés.

## When to use

- **Auto-trigger**: Whenever creating, refactoring, styling, or reviewing web UI
  pages, layouts, components, tables, forms, modals/drawers, design tokens, CSS,
  or client-side state/API integration across React, Next.js, Vue, Nuxt, Svelte,
  Astro, or vanilla HTML/CSS/TypeScript.
- **Explicit trigger**: `/frontend-craft`, `"frontend craft"`, `"ui spec"`,
  `"design system audit"`, `"前端规范"`, `"UI 规范"`, `"去 AI 味"`—including
  auditing an existing frontend codebase for visual drift or missing UX states.
- **Complementary boundary**: Focuses on UI design systems, cross-page
  consistency, component/state architecture, UX states, and distilled native web
  baselines; coexists cleanly alongside browser-API lookup plugins if installed.

Do **not** apply this skill to pure backend services, database migrations, CLI
scripts, CI/CD pipelines, or non-UI build tooling changes.

---

## Three-Step Execution Loop (`前置侦察 → 按规实现 → 交付自检`)

Every frontend creation, modification, or refactor MUST follow this closed loop:

### Step 1: Iron Law 1 — Recon-First Gate (`铁律一：存量侦察锁`)

**Never** write or style UI code in a vacuum. Before creating or editing any
page or component, inspect the repository read-only in this exact order:

1. **Theme & Design Tokens**: Check `tailwind.config.*`, CSS `@theme` / `:root`
   token files (`globals.css`, `tokens.css`, `variables.css`), and theme
   providers to lock onto existing color, font, radius, and spacing tokens.
2. **Global Layout Shell**: Locate `AppLayout`, `PageShell`, route layouts,
   navigation chrome, and standard page gutters.
3. **Shared Component Inventory**: Scan `components/ui/`, `components/shared/`,
   and `package.json` UI libraries (`shadcn/ui`, Radix, AntD, Element Plus,
   Headless UI, etc.).
   - **Reuse or Extend — Never Fork**: If a shared component already exists,
     **reuse it**. If it lacks ~10% of needed capability, **extend the shared
     component cleanly** (backward-compatibly) instead of hand-rolling a bespoke
     duplicate or introducing a second competing UI/CSS library.
4. **Canonical Sibling Page (`同类型标杆兄弟页`)**: Read **1 existing page of
   the same archetype** (e.g., an existing list/ledger page before building a
   new list page) and mirror its header rhythm, filter placement, table wrapper,
   and action button ordering.

> **0-to-1 Greenfield Rule (`全新项目先立基建`)**: When starting an empty
> frontend project, **never** jump straight into writing the first business
> page. Establish the foundational triad first:
> 1. Global 3-tier Design Tokens (`Primitive → Semantic → Component`) + `@layer`
> 2. Standard `PageShell` layout skeleton(s)
> 3. Core shared primitives (`Button`, `Input`, `Dialog/Drawer`, `DataTable`,
>    `EmptyState`, `StatusBadge`)

---

### Step 2: Iron Law 2 — Product Archetype Routing & Reference Loading (`铁律二：多产品形态分流与按需加载`)

#### 2A. Identify the Product Mode (`识别产品形态，拒绝生搬硬套`)

Match information density, spatial rhythm, and visual expression to the actual
product domain—never force stiff B2B table chrome onto a brand landing page, or
marketing hero theatrics onto an operational ledger:

| Product Mode | Typical Surfaces | Density & Layout Strategy | Visual & Motion Posture |
| :--- | :--- | :--- | :--- |
| **Mode A: B2B Admin / Ledger**<br>(`B2B 高密度数据后台 / 台账`) | ERP, CRM, finance/contract ledgers, ops consoles, audit tables | High information efficiency; compact `13px–14px` data density; standardized `PageShell` + unified `DataTable` (`tabular-nums`, sticky row actions) | Crisp hairline borders, neutral surfaces, single restrained accent, instant/micro transitions (`150ms`), zero decorative fluff |
| **Mode B: SaaS / Studio Workbench**<br>(`交互式 SaaS / 创作工作台`) | Project trackers, AI/code/design studios, Linear/Notion-style workspaces | Viewport-locked `100dvh` multi-pane canvas; independent pane scrolling; command/keyboard ergonomics; inline editing & optimistic feedback | Low-contrast chrome that recedes behind user content, subtle elevation on floating popovers, tactile focus/hover cues |
| **Mode C: Brand Landing / Consumer**<br>(`品牌叙事落地页 / C 端应用`) | Marketing sites, product launches, portfolios, editorial/consumer apps | Intentional focal hierarchy; generous breathing whitespace; editorial display/body typography contrast; asymmetric or story-driven sections | Crafted atmosphere via typography, real photography/bespoke SVG, and choreographed `prefers-reduced-motion`-safe reveals—zero generic SaaS purple-glow templates |

#### 2B. Load Only the Relevant Reference Modules (`渐进式按需读取规范模块`)

Read the specific reference file(s) under `references/` matching your task
**before** writing code (skip unrelated modules to keep context lean):

| Task / Touchpoint | Required Reference Module | Core Focus |
| :--- | :--- | :--- |
| Creating/refactoring a **page, layout shell, table, modal/drawer, badge**, or fixing cross-page drift | [`references/01-consistency-and-archetypes.md`](references/01-consistency-and-archetypes.md) | 4 page archetypes (List, Form, Detail, Workbench) & single composite contracts (`DataTable`, `Dialog/Drawer`, `EmptyState`, `StatusBadge`) |
| Setting up **tokens, themes, colors, fonts, spacing, dark mode**, or polishing **visual craft** | [`references/02-ui-tokens-and-craft.md`](references/02-ui-tokens-and-craft.md) | 3-tier token chain + `@layer`, locked font/gray/3-tier spacing dictionary, and Anti-AI-Slop `Do / Don't` red lines |
| Designing **components, props/slots, hooks/composables, stores, URL sync, or API/TS layers** | [`references/03-component-and-state-arch.md`](references/03-component-and-state-arch.md) | 3-layer component boundaries (`ui → features → pages`), 250-line cap, 4-way state taxonomy, AbortSignal & DTO/ViewModel decoupling |
| Implementing **async data views, forms, validation, keyboard shortcuts, or accessibility** | [`references/04-ux-states-forms-a11y.md`](references/04-ux-states-forms-a11y.md) | Mandatory 5 async states (`Loading / Empty / Error / Overflow / Pending`), blur-delayed validation, `!event.isComposing`, dirty-leave guard, semantic DOM |
| Building **overlays, responsive cards, CSS state selectors, typography/color tweaks, media, or motion** | [`references/05-modern-web-baseline.md`](references/05-modern-web-baseline.md) | Native `<dialog>`/`popover`, `@container`, `100dvh`, `:has()`, `tabular-nums`, `text-wrap`, `field-sizing`, `color-mix()`, CLS & `prefers-reduced-motion` |

> **Full-Page Rule**: When building a brand-new page end-to-end, read **`01` +
> `02` + `04`** at minimum (plus `03` if adding state/API logic, and `05` for
> layout/overlay primitives).

---

### Step 3: Pre-Delivery Self-Check (`交付前一致性与五态自检 Checklist`)

Before finishing any frontend task, verify every modified file against these 6
release gates and fix violations immediately:

- [ ] **Sibling & Shared Parity (`一致性闭环`)**: Uses the project's existing
      `PageShell`, `DataTable`, `Dialog/Drawer`, and `StatusBadge`—zero bespoke
      page headers, duplicate table wrappers, or rival UI/icon libraries.
- [ ] **Token & Anti-Slop Discipline (`视觉纯净度`)**: Zero hardcoded magic
      hex/rgb values or arbitrary pixel spacing in feature components; zero
      default blue-purple neon gradients, glowing cards, badge spam, or Emoji
      substituting for UI icons.
- [ ] **Component & State Hygiene (`架构清晰度`)**: Single component files stay
      under the complexity ceiling (~250 lines) with zero stateful inline child
      components; server cache, URL query params (filters/tabs/page), local UI
      state, and global store are cleanly separated with zero `any` or swallowed
      API errors.
- [ ] **5-State Completeness (`异步五态必全`)**: Every data-driven view/action
      explicitly covers `Loading` (skeleton/local indicator, no full-screen
      freeze), `Empty` (context + next action), `Error` (inline message +
      retry), `Overflow` (`min-width: 0` + truncation/wrap + `tabular-nums` +
      `—` empty cells), and `Pending` (submit lock against double clicks).
- [ ] **Form & Semantic A11y (`表单与无障碍`)**: Validation errors wait until
      blur/submit (never red on initial blank mount); Enter-key handlers check
      `!event.isComposing` for CJK IME safety; dirty forms guard accidental
      exit; interactive controls use native `<button>`/`<a>` with `aria-label`
      on icon-only buttons.
- [ ] **Modern Native Baseline (`现代原生基线`)**: Uses `<dialog>`/`popover` or
      accessible headless primitives over `z-index` hacks, `100dvh` over
      `100vh`, `@container` for reusable widgets, intrinsic media dimensions
      against CLS, and honors `prefers-reduced-motion`.

---

## Anti-patterns

- Writing a new route without inspecting the repo's tokens, layout shell, shared
  components, and 1 sibling page—creating a "patchwork monster" (`散装缝合怪`).
- Installing a second UI/icon library or hand-rolling duplicate tables/modals
  when a shared component already exists in the project.
- Defaulting to AI-slop aesthetics: blue-purple neon gradients, glowing cards,
  pill/badge clutter, or Emoji used as product UI icons.
- Shipping happy-path-only views that omit `Loading`, `Empty`, `Error`,
  `Overflow`, or `Pending` states, or painting untouched blank forms red on mount.
- Firing Enter-submit handlers during CJK IME composition (`event.isComposing`),
  copying server query cache into global stores, or swallowing API errors into `[]`.

