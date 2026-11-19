# 04 — Five-State UX Views, Form Engineering & Semantic A11y (`五态必全、表单实战细节与无障碍语义`)

Eliminate the most common production UX bugs in AI-written frontend code:
happy-path-only views that crash or freeze under real data, premature red form
walls, broken Chinese/Japanese/Korean IME Enter handling, and inaccessible
`<div onClick>` controls.

---

## 1. Mandatory 5-State Async View Contract (`数据驱动视图五态必全契约`)

Every page, table, card widget, or drawer backed by async data or user input
MUST explicitly implement and verify **all five states**—never ship only the
"3 mock items loaded" happy path:

### 1.1 `Loading` (`加载态：禁动辄全屏遮罩死转圈`)

- **Initial mount**: Render a **geometry-matched Skeleton** matching the exact
  header/row/card dimensions of the loaded view so layout height does not jump.
- **Background refresh / filter / pagination transition**: Keep existing data
  visible (`keepPreviousData` / subtle `opacity` dim + inline spinner in toolbar
  or top progress hairline). **Never** slap a full-screen blocking overlay
  spinner across the entire viewport for routine reads or table filtering!
- **Anti-flicker**: Avoid flashing spinners for sub-`120ms` cached responses.

### 1.2 `Empty` (`空状态：说明原因 + 下一步行动引导`)

Distinguish the **two distinct empty scenarios**—never show a bare `"No Data"`
string:

- **Zero records created yet (`首次无数据`)**: Neutral monochrome line icon +
  concise explanation of what lives here + primary CTA (`"Create First
  Contract"` / `"Import CSV"`).
- **Zero filter/search matches (`筛选无匹配结果`)**: State clearly `"No results
  match current filters"` + 1-click **`"Clear Filters"`** button that resets
  URL query filters immediately.

### 1.3 `Error` (`异常态：局部容错 + 一键重试，严禁白屏崩溃`)

- Render an inline error state inside the failed section/card/table (not a
  full-app white screen of death), isolating failures with route/widget Error
  Boundaries.
- Display a human-readable message (never raw stack traces or `[object Object]`)
  paired with an explicit **`"Retry"`** button that re-triggers the failed query
  while preserving the user's current filters or draft inputs.

### 1.4 `Overflow` (`极端数据防撑破态`)

Stress-test layouts mentally against real dirty production strings:

- **Flex & Grid shrinkage lock**: Add **`min-width: 0`** (`min-w-0`) on flex and
  grid children containing variable text—without it, a single 80-character
  filename, URL, or unbroken ID blows past container bounds!
- **Long text & multiline clamping**: Single-line titles/cells use `truncate`
  (`overflow: hidden; text-overflow: ellipsis; white-space: nowrap`) with
  accessible full-text disclosure where needed; card descriptions use
  `line-clamp-2` / `line-clamp-3`.
- **Multi-tag & action wrapping**: Tag groups use `flex-wrap` or `+N more`
  collapse; huge numbers format cleanly (`tabular-nums`, compact or grouped
  thousands) without wrapping mid-digit.

### 1.5 `Pending` (`异步提交锁定态：防连点重复提交`)

- Every form submission, row mutation, or confirmation button MUST enter a
  locked `Pending` state (`disabled` or `aria-busy="true"`) on the **first
  activation** until the promise settles.
- **Preserve button geometry**: Swap in an inline spinner while keeping button
  width stable (or concise pending label) so adjacent Cancel buttons don't shift.
- When applying optimistic updates (e.g., toggling star/archive), snapshot prior
  state and **roll back cleanly with user-visible error feedback** if the
  mutation fails.

---

## 2. Production Form Engineering Details (`表单实战细节规范`)

1. **Structured Schema Validation (`结构化 Schema 校验`)**:
   - Define non-trivial form rules once in a declarative schema (`Zod`,
     `Valibot`, `Yup`, or typed form-library rules) driving both static
     TypeScript types and field-level error messages—avoid scattered imperative
     `if (!val.trim())` spaghetti inside submit handlers.
2. **Blur-Delayed Validation Timing (`交互/失焦后延迟报错，严禁开屏满眼飘红`)**:
   - **Never** display validation errors on untouched fields when a blank form
     first mounts (align with native CSS `:user-invalid` semantics).
   - **Reward-Early, Punish-Late**: Validate a field first on **`blur`** (or
     first **`submit`** attempt); once a field is marked invalid, re-validate
     eagerly on **`input`/`change`** so the red error clears the instant the
     user fixes the value.
   - On failed submit, **move focus and smooth-scroll to the first invalid
     field** (`aria-invalid="true"`, linked to error text via
     `aria-describedby`).
3. **CJK IME Composition Guard (`中文输入法回车防误提交：!event.isComposing`)**:
   - Whenever binding `keydown` (`Enter`) on an `<input>`, `<textarea>`, search
     box, chat composer, or tag input to submit or confirm, **MANDATORILY guard
     against active IME composition**:
     ```ts
     function handleKeyDown(e: KeyboardEvent) {
       // Prevent confirming Pinyin/Japanese/Korean IME candidates from firing submit!
       if (e.isComposing || e.keyCode === 229) return;
       if (e.key === 'Enter' && !e.shiftKey) {
         e.preventDefault();
         submit();
       }
     }
     ```
     *(In React synthetic events, check `e.nativeEvent.isComposing || e.keyCode === 229`.)*
4. **Dirty-Form Unsaved Leave Guard (`脏表单未保存离开拦截`)**:
   - For multi-field creation/edit forms or drawers, track `isDirty` (comparing
     against initial values):
     - Register a `beforeunload` listener while `isDirty && !isSubmitting` to
       guard accidental tab close/refresh.
     - Guard in-app route transitions and **prevent accidental backdrop-click /
       `Esc` dismissal** on dirty modals/drawers without confirmation.
5. **Input Ergonomics**:
   - Every control MUST pair with a clickable `<label for="...">` (placeholder
     text is **never** a substitute for a label!).
   - Set explicit `type`, `inputmode` (`numeric`, `decimal`, `tel`, `email`,
     `search`), and `autocomplete` tokens (`email`, `current-password`,
     `one-time-code`, `organization`).

---

## 3. Semantic DOM, Keyboard Loop & Automation Stability (`无障碍与自动化友好语义`)

1. **Native Interactive Elements Only (`严禁 <div onClick>`)**:
   - **Actions** that mutate state, open modals, toggle menus, or submit forms
     MUST be `<button>`—and **always set `type="button"` explicitly** on
     non-submit buttons (inside `<form>`, an untyped `<button>` defaults to
     `type="submit"` and triggers accidental form reloads!).
   - **Navigations** to a URL/route MUST be `<a href="...">` (or router `<Link>`)
     so Cmd/Ctrl+Click, middle-click, context menu `"Copy link"`, and screen
     readers work natively.
   - **Never** attach click handlers to non-interactive `<div>`, `<span>`, or
     `<svg>` elements.
2. **Icon-Only Button & Decorative SVG Rule (`纯图标按钮必配 aria-label`)**:
   - Every icon-only button (close `×`, row menu `⋯`, copy, filter, delete) MUST
     include a clear, action-specific `aria-label` (e.g.,
     `aria-label="More actions for contract HT-UPLOAD-002"`), while inner
     decorative `<svg>` elements carry `aria-hidden="true"`.
   - Maintain a minimum comfortable hit target (**`≥ 32px–36px`** on desktop
     dense UI, **`≥ 44px × 44px`** on touch/mobile viewports).
3. **Keyboard Focus & UI Test Determinism (`键盘焦点闭环与自动化测试定位稳定`)**:
   - Preserve visible `:focus-visible` rings (`2px` high-contrast offset ring;
     never strip `outline: none` without a `:focus-visible` replacement).
   - Overlays/modals MUST trap `Tab` / `Shift+Tab` inside while open, close on
     `Esc` (when clean), and **restore focus to the trigger button** on close.
   - Semantic roles (`role`, `<button>`, `<th>`, `<dialog>`), explicit
     `<label>`/`aria-label` names, and truthful state attributes
     (`aria-expanded`, `aria-selected`, `aria-invalid`, `disabled`) ensure
     Playwright, Testing Library, and Chrome DevTools agents can locate and
     verify every interaction cleanly via `getByRole` / `getByLabel` without
     brittle CSS class selectors.
