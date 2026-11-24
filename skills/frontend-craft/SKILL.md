---
name: frontend-craft
description: >-
  Web UI consistency, anti-AI-slop, 5-state UX & CJK form rules for UI
  builds/refactors (NOT read-only reviews, git syncs, non-UI logic, or 1-line
  tweaks). Triggers: /frontend-craft, "frontend craft", "ui spec", "前端规范",
  "UI 规范", "去 AI 味".
license: MIT
metadata:
  author: ainward
  version: "2.0.0"
---

# Frontend Craft

Build cohesive, production-grade web interfaces across React, Next.js, Vue, Nuxt,
Svelte, Astro, and vanilla HTML/CSS/TypeScript—matching repository conventions,
eliminating AI-slop visuals, and enforcing complete async UX states, CJK-safe
forms, clean state boundaries, and modern native web primitives.

## 1. Proportional Scope & Recon

Skip this skill on read-only code reviews, git syncs, pure non-UI state/TS logic,
backend/CLI/infra code, or build-only config edits. Scale recon to task scope:

- **1-Line / Localized Tweak**: Match surrounding tokens and conventions directly
  in-file; skip multi-file repo scans; **never** rewrite, split, or refactor
  untouched legacy code in the file.
- **New / Rebuilt Component or Page**: Inspect repo tokens (`tailwind.config.*`,
  CSS `@theme` / `:root`), layout shells (`AppLayout`, `PageShell`), shared
  `components/ui/` + `package.json` UI/icon libraries, and **1 canonical sibling
  route** first. Reuse or cleanly extend shared primitives—never fork raw
  `<div class="p-6 flex ...">` page chrome or install rival UI/icon libraries.
- **0-to-1 Greenfield**: Scaffold semantic tokens + layout/primitives proportional
  to app scope (establish tokens + `PageShell` + core primitives first on
  multi-route apps; avoid unused admin table/badge scaffolding on a landing page
  or single-screen prototype).

## 2. Density & Layout Contracts

- **Product Density Modes**:
  - **B2B Compact (`13px–14px`)**: High-density neutral surfaces, crisp hairline
    borders, `150ms` transitions; **ban tall hero metric cards** pushing tables
    below the fold (use compact inline summary/filter strips).
  - **`100dvh` Split Workbench**: Viewport-locked `height: 100dvh; overflow: hidden`
    outer shell (**zero outer-body double scrollbars**) with independent scrolling
    master, canvas (`flex: 1; min-width: 0`), and inspector panes.
  - **Brand Editorial**: Intentional focal hierarchy, generous whitespace, real
    imagery/bespoke SVG, and `prefers-reduced-motion`-safe reveals.
- **Form Width & Grid Containment**: Cap single-column forms at **`640px–800px`**
  (`max-w-2xl`/`max-w-3xl`) in 3–7 field sections with consistent `Cancel` +
  `Save/Submit` footers. Asymmetric CSS Grids **MUST bound tracks with
  `minmax(0, ...)`** (e.g. `minmax(0, 2fr) minmax(280px, 1fr)`) and `min-w-0` to
  prevent wide `<pre>`, URLs, or tables from blowing out viewport width.
- **Single Composite Contracts**:
  - **`DataTable`**: Render `null`/`undefined`/`""` cells as muted **`—`** (never
    `"null"`, `"N/A"`, `"-"`, or blank); right-align (`<th>` and `<td>`) money,
    counts, percentages, and timestamps with **`tabular-nums`**; pin wide-table
    actions to sticky right (`inset-inline-end: 0`) and fold **`> 3` actions**
    into a **`More (⋯)`** menu.
  - **`Dialog` vs. `Drawer`**: Centered `Dialog` for confirmations and **`≤ 5`
    fields**; `Drawer / Sheet` (`100dvh`) for previews, logs, or **`> 5` fields**.
  - **`EmptyState` & `StatusBadge`**: Single monochrome SVG `EmptyState`; map
    status enums via **one centralized semantic tone map**
    (`neutral | info | success | warning | danger`) repo-wide.

## 3. Tokens & Anti-AI-Slop

- **3-Tier Tokens & `@layer`**: Wire `Primitive -> Semantic -> Component`
  unidirectionally (features consume Semantic tokens only; themes swap Tier 2
  only). Govern specificity via `@layer`, ban `!important` outside a11y/print, and
  ban hardcoded magic hex/rgb or off-grid pixel literals (`13px`, `27px`).
- **Visual Dictionary**: Lock **1 UI sans** (+ optional Brand display font), **1
  monospace font**, **3 macro spacing tokens** (`--space-page`, `--space-section`,
  `--space-card`), and **1 neutral ramp** on a **`90 / 8 / 2` ratio** (~90%
  neutral surfaces/text, ~8% hairline borders/muted text, ≤2% accent for primary
  CTA and active state).
- **Anti-AI-Slop Bans**: Ban indigo-purple-pink neon gradients, glowing or
  3-level nested cards, muddy static drop shadows, **`> 1` pill per row/card**
  (format secondary metadata as `·`-separated muted text), and **Emojis (`🚀✨`)
  as UI icons** (use one uniform `1.5px–1.75px` vector set with `currentColor`).

## 4. 5-State Async UX & CJK-Safe Forms

- **Mandatory 5 Async States**:
  - **`Loading`**: Geometry-matched initial skeleton; keep rows visible
    (`keepPreviousData` / toolbar indicator) on filter/page changes—**never**
    block routine reads with a full-screen spinner.
  - **`Empty`**: Separate **first-use empty** (context + primary CTA) from **zero
    filter matches** (message + 1-click **`Clear Filters`**).
  - **`Error`**: Inline error boundary + **`Retry`** preserving filters/drafts—**ban
    `catch { return []; }`** silent swallowing that disguises errors as empty.
  - **`Overflow`**: Enforce **`min-width: 0`** (`min-w-0`) on flex/grid text
    children, `truncate` / `line-clamp-*`, and tag `flex-wrap` / `+N` collapse.
  - **`Pending`**: Lock submit/mutation buttons (`disabled` / `aria-busy`) on
    first click without width jitter; roll back failed optimistic updates cleanly.
- **Forms, CJK IME & Semantic DOM**: Delay validation errors until **`blur`** or
  first **`submit`** (`:user-invalid`—never red on blank mount), clear eagerly on
  `input`, and focus the first `aria-invalid="true"` field on failed submit.
  Guard `Enter`-to-submit `keydown` handlers against CJK IME composition:
  **`if ((e.nativeEvent?.isComposing ?? e.isComposing) || e.keyCode === 229) return;`**.
  Confirm before closing dirty forms (`beforeunload`, route leave, backdrop/`Esc`);
  pair inputs with `<label>`, use `<button type="button">` vs. `<a href>` (**ban
  `<div onClick>`**), and require `aria-label` on icon-only buttons.

## 5. Component/State Boundaries & Native Baseline

- **Boundaries & State**: Enforce one-way `pages -> features -> ui` imports (~250L
  split target on **new/rebuilt** components only; **ban stateful child components
  defined inside parent render**). Keep API data in **Server Cache** (Query / SWR
  / RSC / `useAsyncData`—never mirror into Zustand/Pinia/Redux), sync **list
  filters, sort, tabs, and page to URL search params**, **compute derived/filtered
  state synchronously during render (`computed` / `$derived`—ban `useEffect` /
  `watch` → `setState` mirroring)**, pass `AbortSignal` on filter races, and ban
  bare `any` (map raw DTOs at the API boundary).
- **Native Baseline**: Native `<dialog>` **MUST call `ref.showModal()` /
  `ref.close()`** (**never** bind `<dialog open={isOpen}>`); prefer `popover` or
  headless primitives over `z-index` / `body.style.overflow` hacks
  (`scrollbar-gutter: stable`). Use `@container` on widgets, `100dvh` (+
  `safe-area-inset-bottom`), `:has()`, `text-wrap: balance/pretty`, bounded
  `field-sizing: content`, `color-mix(in oklab)`, explicit media `aspect-ratio`
  (`fetchpriority="high"` hero, `loading="lazy"` below fold), and `150ms–250ms`
  `transform`/`opacity` transitions (**ban `transition: all`**) honoring
  `prefers-reduced-motion`.
