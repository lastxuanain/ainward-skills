# 05 — Modern Native Web Baseline (`现代原生 HTML/CSS 离线编码基线`)

Prefer battle-tested, Baseline-ready native HTML and CSS capabilities over
fragile legacy JavaScript workarounds, manual DOM measurement listeners, and
`z-index` wars.

---

## 1. Overlays, Dialogs & Popovers (`浮层与原生顶层交互基线`)

- **Modals & Drawers → `<dialog>` or Standard Headless Primitives**:
  - Build modal dialogs and sheets on native `<dialog>` (`dialog.showModal()` /
    `dialog.close()`) or accessible headless primitives (`Radix`, `Ark UI`,
    `React Aria`, `Headless UI`, `Reka UI`) that manage top-layer promotion,
    `::backdrop`, `Esc` dismissal, focus trapping, and background `inert`
    semantics cleanly.
  - **Note on React/Vue**: Invoke `showModal()` / `close()` via a `ref` synced
    with open state rather than toggling only the HTML `open` attribute (which
    skips modal top-layer promotion and backdrop).
- **Lightweight Menus, Tooltips & Filters → `popover` + Anchor Positioning**:
  - Prefer native `popover="auto"` (`popovertarget`) or standard floating
    primitives for light-dismiss menus and non-modal popovers—promoting elements
    into the browser `#top-layer` without clipping inside `overflow: hidden`
    parents.
- **Strictly Forbidden Legacy Hacks**:
  - Ban arbitrary `z-index: 999999` escalation across components.
  - Ban fragile `document.body.style.overflow = 'hidden'` patches that shift page
    width when scrollbars disappear (use `:root { scrollbar-gutter: stable; }`
    when layout stability across scroll states is needed).

---

## 2. Modern CSS Layout, Viewport & Relational State (`现代 CSS 布局与状态关联`)

### 2.1 `@container` for Components, `@media` for Page Shells (`容器查询优先`)

- **Macro Page Skeletons** (`Sidebar` collapse, multi-column `Detail` grid): use
  viewport `@media` breakpoints.
- **Reusable Components** (`MetricCard`, `FilterItem`, `EntityCard` placed inside
  sidebars, drawers, or variable grids): declare `container-type: inline-size`
  on the slot wrapper and adapt internal layout via `@container (min-width:
  24rem)` so the component responds to its **actual available width**, not the
  browser window!

### 2.2 Dynamic Viewport Units (`100dvh` 替代 `100vh`)

- Full-screen workbenches, mobile drawers, login stages, and sticky sidebars
  MUST use **`100dvh`** (`min-h-dvh` / `h-dvh`, optionally with `100vh` fallback
  only if targeting pre-2022 WebViews) instead of `100vh` so dynamic mobile
  browser address/toolbars never clip bottom sticky action buttons.
- Pair bottom-pinned mobile toolbars with `padding-bottom: max(var(--space-card),
  env(safe-area-inset-bottom))`.

### 2.3 Relational `:has()` State Styling (`用 :has() 消除冗余 JS 状态`)

Replace boilerplate `isFocused` / `isChecked` / `hasError` JS state listeners
with native CSS relational selectors:

```css
/* Highlight composite input wrapper when inner input has keyboard focus */
.input-shell:has(input:focus-visible) {
  border-color: var(--accent-primary);
  box-shadow: 0 0 0 3px color-mix(in oklab, var(--accent-primary) 16%, transparent);
}

/* Style selectable option card directly from its native radio/checkbox state */
.option-card:has(input:checked) {
  border-color: var(--accent-primary);
  background: color-mix(in oklab, var(--accent-primary) 6%, var(--bg-surface));
}

/* Reveal invalid styling only after user interaction */
.field-group:has(:user-invalid) .field-hint {
  color: var(--status-danger);
}
```

---

## 3. Typography Polish, Native Form Sizing & Semantic Color Mixing (`排版、原生表单与混色`)

1. **Tabular Numerals (`font-variant-numeric: tabular-nums`)**:
   - Apply `tabular-nums` on all table numeric/date columns, KPI counters, badge
     counts, timers, prices, and progress percentages so changing digits never
     jitter horizontally.
2. **Optical Line Wrapping (`text-wrap: balance / pretty`)**:
   - Apply `text-wrap: balance` to multi-line page titles, section headings,
     modal headers, and empty-state titles (≤ 6 lines) for even visual weight.
   - Apply `text-wrap: pretty` to body paragraphs, card summaries, and helper
     captions to prevent awkward trailing single-character/single-word orphans
     (`消除单字孤行`).
3. **Auto-Growing Inputs & Native Control Tinting (`field-sizing` 与 `accent-color`)**:
   - For auto-expanding `<textarea>` composers or inline inputs, apply
     progressive `field-sizing: content` bounded strictly by `min-height` and
     `max-height` (`overflow-y: auto`) before reaching for resize-observer DOM
     clone hacks.
   - Set `accent-color: var(--accent-primary)` on `:root` so native checkboxes,
     radios, and `<progress>` controls automatically match the project brand
     without heavy custom rewrites when native controls suffice.
4. **Dynamic Translucent & Hover Surfaces via `color-mix()` (`语义变量动态混色`)**:
   - Derive hover overlays, subtle badge backgrounds, and hairline borders from
     semantic tokens using perceptual `oklab` / `srgb` mixing:
     ```css
     .btn-ghost:hover {
       background: color-mix(in oklab, var(--text-primary) 6%, transparent);
     }
     .badge-warning {
       color: var(--status-warning);
       background: color-mix(in oklab, var(--status-warning) 12%, transparent);
       border: 1px solid color-mix(in oklab, var(--status-warning) 24%, transparent);
     }
     ```
   - This automatically adapts across Light and Dark themes without maintaining
     fragile parallel `--brand-alpha-10`, `--brand-alpha-20` hex tables.

---

## 4. Media CLS Prevention & Restrained Motion Baseline (`防布局偏移与克制动效底线`)

1. **Zero Cumulative Layout Shift (`媒体宽高比锁死防 CLS`)**:
   - Every `<img>`, `<video>`, avatar, and chart/embed container MUST reserve
     layout space upfront via explicit `width` & `height` attributes or CSS
     `aspect-ratio` (`aspect-ratio: 16 / 9`, `aspect-ratio: 1`) paired with
     `object-fit: cover`.
   - Below-the-fold images use native `loading="lazy" decoding="async"`; the
     single above-the-fold hero/LCP image uses `fetchpriority="high"` and MUST
     NOT be lazy-loaded.
2. **Crisp Micro-Interactions (`150ms–250ms 自然缓动`)**:
   - Keep interactive transitions fast and responsive: **`120ms–180ms`** for
     hover/focus/press feedback, **`180ms–250ms`** for dialogs, drawers, and
     popovers, using natural deceleration curves (`cubic-bezier(0.16, 1, 0.3,
     1)` or `ease-out`)—ban sluggish `500ms+` UI transitions and cartoonish
     overshoot bounces in productivity tools.
   - Animate **only compositor-friendly properties** (`transform`, `opacity`, or
     targeted `color`/`background-color`/`border-color`)—**never write
     `transition: all`**.
   - For native `<dialog>` / `[popover]` discrete entry/exit transitions,
     progressively layer `@starting-style` + `transition-behavior:
     allow-discrete` cleanly at top level.
3. **Mandatory `prefers-reduced-motion` Respect (`全局减弱动态效果兜底`)**:
   - Always honor OS accessibility motion preferences globally:
     ```css
     @media (prefers-reduced-motion: reduce) {
       *, *::before, *::after {
         animation-duration: 0.01ms !important;
         animation-iteration-count: 1 !important;
         transition-duration: 0.01ms !important;
         scroll-behavior: auto !important;
       }
     }
     ```
