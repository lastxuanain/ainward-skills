# 02 — UI Tokens, Typography/Spacing Dictionary & Anti-AI-Slop (`三级视觉字典与去 AI 塑料感红线`)

Lock down a disciplined, token-driven visual system and eliminate the telltale
"AI-generated template" look (`AI 廉价塑料感`) before writing component styles.

---

## 1. Three-Tier Unidirectional Token Discipline (`三级单向变量纪律`)

Structure CSS custom properties (and Tailwind `@theme` / `theme.extend`
mappings) strictly along a **one-way reference chain**:

```text
Primitive (原始色板与尺度)  ──▶  Semantic (语义角色变量)  ──▶  Component (组件局部映射)
```

1. **Tier 1 — `Primitive` (`原始原子值`)**: Raw palette ramps, base spacing unit,
   and font families. **Never** reference Primitive tokens directly inside
   business/feature components.
2. **Tier 2 — `Semantic` (`全局语义变量`)**: Role-based tokens describing
   *purpose*, not hue (`--bg-canvas`, `--bg-surface`, `--bg-elevated`,
   `--text-primary`, `--text-secondary`, `--text-muted`, `--border-subtle`,
   `--border-strong`, `--accent-primary`, `--status-danger`). Theme switching
   (Light / Dark / High-Contrast) ONLY reassigns Tier 2 values.
3. **Tier 3 — `Component` (`组件局部令牌`, optional)**: Scoped aliases on complex
   shared primitives (`--table-header-bg: var(--bg-subtle)`).

### CSS `@layer` Cascade Governance

Declare explicit cascade layers at the stylesheet entrypoint so base resets,
tokens, shared components, and utility overrides never fight specificity wars
(**ban `!important` outside print/a11y overrides**):

```css
@layer reset, tokens, base, primitives, components, utilities;

@layer tokens {
  :root {
    /* 1. Primitives (locked single neutral ramp + single brand ramp) */
    --p-neutral-0: #ffffff;
    --p-neutral-50: #f8fafc;
    --p-neutral-100: #f1f5f9;
    --p-neutral-500: #64748b;
    --p-neutral-900: #0f172a;
    --p-brand-600: #2563eb;

    /* 2. Semantics (consumed by pages & features) */
    --bg-canvas: var(--p-neutral-50);
    --bg-surface: var(--p-neutral-0);
    --text-primary: var(--p-neutral-900);
    --text-secondary: var(--p-neutral-500);
    --border-subtle: color-mix(in oklab, var(--p-neutral-900) 8%, transparent);
    --accent-primary: var(--p-brand-600);

    /* 3. Locked 3-Tier Spacing Dictionary */
    --space-page: 1.5rem;    /* 24px: outer PageShell gutter */
    --space-section: 1.5rem; /* 24px: vertical/grid gap between page blocks */
    --space-card: 1.25rem;   /* 20px: internal card/panel padding */
  }
}
```

> **Zero Magic Literals Rule**: Business components MUST NOT hardcode arbitrary
> hex/rgb colors (`#3b82f6`, `rgba(0,0,0,0.07)`) or off-grid magic pixel values
> (`padding: 13px 19px`, `margin-top: 27px`, `font-size: 13.5px`).

---

## 2. Locked Project Visual Dictionary (`全项目锁死的视觉字典`)

Unless an existing repository already defines its own design system (in which
case Recon-First locks onto it), enforce these four dictionary constraints:

1. **Font Stack Lock (`唯一正文字体栈 + 唯一等宽字体栈`)**:
   - **1 Primary Sans/UI Stack** for all body copy, controls, and standard
     headings (plus at most **1 Display/Editorial Serif or Geometric Sans**
     strictly in `Mode C` brand landing pages—never 3+ competing fonts).
   - **1 Monospace Stack** (`--font-mono`) dedicated to IDs (`HT-UPLOAD-002`),
     commit SHAs, API keys, code snippets, and aligned technical metrics.
2. **Fixed Type Scale & Contrast (`固定字号与字重阶梯`)**:
   - Use a tight, deliberate scale (`12px` caption / `14px` dense UI & table /
     `16px` prose body / `18px` card title / `20px–24px` page title /
     `32px–56px` landing display).
   - Create hierarchy via **weight + color contrast** (`600` `--text-primary`
     title paired with `400` `--text-secondary` metadata), not by making every
     label uppercase bold `18px`.
   - Headings use tight line-height (`1.15–1.25`) and subtle negative tracking
     (`-0.015em` to `-0.03em` above `24px`); body copy uses `1.5–1.65`.
3. **Single Grayscale Ramp + Semantic Accents (`唯一灰阶色系 + 克制语义色`)**:
   - Pick **one** neutral family across the entire app (e.g., cool `slate`,
     neutral `zinc`, or warm `stone`)—**never** mix cool blue-grays on the
     sidebar with warm brown-grays on cards and pure `#888` borders in tables.
   - Follow the **90 / 8 / 2 Color Ratio**: ~90% neutral canvas/surface/text,
     ~8% subtle borders & muted secondary tones, **≤ 2% high-chroma accent**
     reserved strictly for the primary CTA, active indicator, and critical status.
4. **3-Tier Macro Spacing Lock (`固定三级间距标尺`)**:
   - Lock **Page Outer Gutter (`--space-page`)**, **Inter-Section Gap
     (`--space-section`)**, and **Card Inner Padding (`--space-card`)** across
     all routes (scaling down one step cleanly on `< 640px` mobile viewports) so
     every screen shares the same spatial cadence.

---

## 3. Anti-AI-Slop Red Lines (`反 AI 廉价塑料感红线：Do / Don't 对照`)

Modern LLMs default to recognizable clichés that scream "unreviewed AI
prototype." Enforce these visual red lines unconditionally unless a user's
explicit brand spec demands otherwise:

| Dimension | ❌ Don't (`AI 塑料感重灾区`) | ✅ Do (`克制专业的现代工程质感`) |
| :--- | :--- | :--- |
| **Color & Gradients**<br>(`色彩与渐变`) | Default indigo-to-purple-to-pink (`from-indigo-500 via-purple-500 to-pink-500`) buttons, rainbow gradient hero text, or neon glowing backgrounds | Solid, high-contrast semantic brand accent (`--accent-primary`) or crisp high-contrast monochrome CTA (`#0f172a` / `#fafafa`) with subtle hover luminance shift |
| **Cards & Surfaces**<br>(`卡片与表面层级`) | Full-screen grids of glowing high-saturation cards, thick colored left borders on every box, or 3 levels of nested cards-inside-cards | Flat canvas (`--bg-canvas`) + clean elevated surface (`--bg-surface`) separated by **low-opacity hairline borders** (`6%–10%` alpha) + soft multi-layer ambient shadow only on floating/elevated layers |
| **Badges & Pills**<br>(`胶囊徽章克制`) | Slapping 4–5 colored rounded-full pills (`Active`, `Pro`, `v2`, `AI`, `Hot`) onto every card header and table row | Reserve `StatusBadge` strictly for **1 actionable state per entity**; render secondary metadata (timestamps, categories, counts) as quiet `--text-secondary` text separated by `·` |
| **Iconography**<br>(`图标规范`) | Using Emojis (`🚀`, `✨`, `📊`, `💡`, `🔥`, `⚡`) as sidebar nav icons, button icons, feature card bullets, or empty-state graphics | Use **one uniform vector icon set** (`lucide`, `phosphor`, or repo SVG icons) with consistent `1.5px–1.75px` stroke width, `16px`/`20px` optical size, and `currentColor` inheritance |
| **Shadow & Depth**<br>(`阴影与景深`) | Heavy muddy `box-shadow: 0 10px 25px rgba(0,0,0,0.25)` on static inline cards, or glowing colored drop shadows everywhere | Subtle two-step ambient shadow (`0 1px 2px rgb(0 0 0 / 0.04), 0 4px 12px rgb(0 0 0 / 0.03)`) in light mode; rely on **surface lightness steps + inner top hairline highlight** (`inset 0 1px 0 rgb(255 255 255 / 0.06)`) in dark mode |
| **Whitespace & Hierarchy**<br>(`留白与视觉锚点`) | Cramming equal-weight boxes into every square pixel with uniform `p-4 gap-4`, leaving no clear primary focal point | Give each screen **1 unmistakable primary focal point** and **1 primary CTA**; separate distinct logical groups with generous `--space-section` whitespace instead of drawing extra divider boxes |
