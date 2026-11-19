# 01 — Cross-Page Consistency & Standard Archetypes (`跨页面一致性治理与标准母版`)

Prevent multi-page frontend repositories from degenerating into a **"patchwork
monster" (`散装缝合怪`)** where every AI-generated route invents its own outer
padding, header markup, filter toolbar, table cell formatting, and modal chrome.

---

## 1. Sibling-Page Parity Rule (`标杆兄弟页对齐原则`)

Before writing or refactoring any route:

1. **Match structural rhythm**: Outer page gutters, title hierarchy, breadcrumb
   position, primary CTA placement (top-right in headers; right-aligned or
   explicit primary position in footers), and section gaps MUST match existing
   sibling routes.
2. **Forbid raw `<div>` chrome reinvention**: Never hand-write `<div class="p-6
   flex items-center justify-between border-b">` page headers or ad-hoc filter
   strips inside individual pages when a shared `PageShell` / `PageHeader` /
   `FilterBar` exists (and if none exists yet, extract one as the canonical
   shared shell).
3. **Extend upward, never fork locally**: When a page needs a slight variation
   (e.g., an extra header slot or secondary toolbar action), add an optional
   typed slot/prop to the shared shell rather than copying 80 lines of layout
   markup into the page.

---

## 2. Four Standard Page Skeleton Archetypes (`四大标准页面骨架母版`)

Every standard application route should map cleanly onto one of four canonical
page archetypes with predictable slot contracts:

### Archetype A: List / Ledger Page (`列表 / 台账页`)

Used for entity directories, order/contract ledgers, audit logs, and resource
inventories.

- **Fixed vertical slot order**:
  1. **`PageHeader`**: Page title + optional record count/subtitle + primary
     creation/import CTA(s) on the trailing edge.
  2. **`FilterToolbar`**: Keyword search + high-frequency status/date/owner
     filters + `Reset` action (when filters active) + optional secondary bulk/export
     actions. **Sync active filters, sort, and page index to URL Query params.**
  3. **`SummaryStrip` *(optional)***: Compact metric/status filter tabs above the
     table—never bloated hero cards that push table rows below the fold.
  4. **`DataTableSection`**: The single unified `DataTable` component hosting
     header, rows, inline `Loading` skeleton, `Empty` state, and `Error` retry
     state inside a stable frame.
  5. **`PaginationBar`**: Total count + page size selector + page navigation,
     pinned cleanly at the bottom of the table container.

### Archetype B: Form / Editor Page (`表单 / 编辑页`)

Used for creating or editing complex domain records, settings, and multi-step
configurations.

- **Fixed vertical slot order**:
  1. **`PageHeader`**: Back navigation / breadcrumb + clear verb-noun title
     (`Create Contract` / `Edit Webhook`) + unsaved-changes (`Dirty`) indicator
     when applicable.
  2. **`Constrained Form Stage`**: Constrain single-column reading/input width
     to **`640px–800px`** (`max-w-2xl` / `max-w-3xl`) so inputs never stretch
     awkwardly across ultrawide monitors. Group fields into semantic
     `FormSection` cards/fieldsets (3–7 fields per section, each with a concise
     section title and optional helper description).
  3. **`Action Footer` (`底部固定或跟随操作栏`)**: Consistent button order across
     the entire app (`Cancel` secondary action + `Save / Submit` primary action
     with `Pending` lock). Use a sticky bottom bar with subtle top hairline
     border when forms scroll past one viewport.

### Archetype C: Detail / Overview Dashboard (`详情 / 看板页`)

Used for single-entity inspection (order detail, customer 360, deployment run,
analytics overview).

- **Fixed vertical slot order**:
  1. **`EntityHeader`**: Breadcrumb + entity identifier/title + unified
     `StatusBadge` + 3–5 scannable key-value metadata items + primary state
     transition CTA + overflow `More (⋯)` menu.
  2. **`Sub-Navigation` *(when multi-faceted)***: URL-synced `Tabs` (`?tab=logs`)
     or section anchors so deep links open the exact sub-view.
  3. **`Asymmetric Two-Column Grid`**: Primary content stage (`minmax(0, 2fr)` —
     line items, specs, charts) paired with a contextual side rail (`minmax(280px,
     1fr)` — approval timeline, audit history, related links), collapsing cleanly
     into a single column below `lg` (`1024px`).

### Archetype D: Split-Pane Interactive Workbench (`双栏 / 多栏交互工作台`)

Used for mail/inbox views, document/code/prompt editors, design tools, and
master-detail triage consoles.

- **Fixed spatial contract**:
  1. **`Viewport-Locked App Frame`**: `height: 100dvh; overflow: hidden` on the
     outer shell—**zero unintended outer-body double scrollbars**.
  2. **`TopCommandBar`**: Compact `44px–52px` header for context breadcrumb,
     mode switches, and save/publish status.
  3. **`Independent Scroll Panes`**:
     - **Left / Master Pane** (`240px–360px`, collapsible or resizable): list
       navigation or tree with its own vertical scroll and keyboard up/down
       selection.
     - **Center / Primary Stage** (`flex: 1; min-width: 0`): main canvas,
       conversation, or detail workspace with independent scroll.
     - **Right / Inspector Rail *(optional)*** (`280px–360px`, toggleable):
       properties, comments, or metadata drawer.

---

## 3. Single Composite Component Contracts (`唯一复合组件契约`)

Across the entire repository, lock down **one canonical implementation** for
each high-frequency composite pattern. Never let two pages render two different
table styles, modal headers, or status pills.

### 3.1 The Single `DataTable` Contract (`全项目唯一封装 DataTable`)

All tabular views MUST build on the project's single encapsulated `DataTable`
(e.g., wrapping TanStack Table / Prime / AntD / shared table primitive) and
enforce five non-negotiable rules:

1. **Unified Chrome**: Identical header height, uppercase/muted header weight,
   border treatment, row hover highlight, filter toolbar slot, and pagination
   footer across every module.
2. **Unified Empty Cell Placeholder (`空单元格统一占位符`)**: Every `null`,
   `undefined`, or empty-string `""` cell value MUST render **`—`** (em-dash,
   styled in `--text-muted`) via a shared cell formatter—**never** render raw
   `"null"`, `"undefined"`, `"NaN"`, `"N/A"`, `"-"`, or ambiguous blank space.
3. **Numeric & Temporal Alignment + `tabular-nums` (`数值与时间列对齐铁律`)**:
   - Columns displaying **currency/amounts (`金额`)**, **counts/quantities
     (`数量`)**, **percentages/deltas (`百分比`)**, and **fixed-width timestamps
     (`时间`)** MUST use **`text-align: right`** (matching both `<th>` and
     `<td>` alignment!) and enforce **`font-variant-numeric: tabular-nums`**
     (`tabular-nums` utility) so decimal points and digits line up vertically.
   - Text, names, tags, and status columns remain `text-align: left`.
4. **Sticky Right Action Column & 3-Action Cap (`右侧固定操作列与折叠红线`)**:
   - Wide tables that scroll horizontally MUST pin the row action column to the
     trailing right edge (`position: sticky; inset-inline-end: 0`) with a solid
     surface background and subtle scroll-state left border/shadow.
   - Render **at most 3 inline row actions** (or 2 primary text/icon actions +
     `⋯`). Whenever a row has **more than 3 actions**, fold low-frequency and
     destructive actions (`Archive`, `Duplicate`, `Delete`) inside a single
     **`More (⋯)` dropdown menu**—never stretch an action column with 5–6
     cramped buttons.
5. **Stable Column Sizing**: Prevent column horizontal jumping across pages or
   loading states (`min-width` / explicit column widths + `truncate` on variable
   text columns).

### 3.2 The Single `Dialog` & `Drawer` Contract (`唯一弹窗与抽屉体系`)

Use one shared `Modal/Dialog` and one shared `Drawer/Sheet` primitive with
deterministic selection rules:

- **When to use `Dialog` (Centered Modal)**: Focused confirmations, destructive
  warnings (explicitly naming the target item), or short forms (**≤ 4–5 simple
  fields**, single viewport, no scrolling sub-tables).
- **When to use `Drawer / Sheet` (Side Panel)**: Quick entity preview without
  leaving a list page, multi-section edit forms (**> 5 fields**), or activity
  logs/audit trails that benefit from vertical height (`100dvh`).
- **Shared Anatomy**: Header (title + optional concise description + accessible
  close `<button aria-label="Close">`), scrollable body (`overflow-y: auto`),
  and fixed footer with consistent Cancel / Confirm button placement.

### 3.3 The Single `EmptyState` & `StatusBadge` Contract (`唯一空状态与状态徽章体系`)

- **`EmptyState`**: One shared component accepting `icon` (clean monochrome line
  SVG, never giant random Emoji), `title`, `description`, and optional `action`
  button (`Create first item` or `Reset filters`).
- **`StatusBadge`**: Map domain status enums (`DRAFT`, `IN_REVIEW`, `APPROVED`,
  `REJECTED`, `ARCHIVED`) through **one centralized semantic tone map**
  (`neutral | info | success | warning | danger`) so `"Pending Approval"` never
  appears amber on Page A, blue on Page B, and purple on Page C.
