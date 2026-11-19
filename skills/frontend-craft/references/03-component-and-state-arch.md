# 03 — Component Topology, 4-Way State & API/Type Architecture (`组件三层职责、状态四分法与接口类型边界`)

Keep frontend codebases modular, predictable, and refactor-safe across **React,
Vue, and Svelte** by enforcing strict unidirectional component layers, clean
state ownership, and race-safe typed API boundaries.

---

## 1. Three-Layer Component Responsibility & Dependency Law (`三层组件职责边界`)

Organize components along a strict **one-way dependency graph**—lower layers
MUST NEVER import from higher layers:

```text
pages / routes / views  ──▶  features / shared-domain  ──▶  ui / primitives
```

### Layer 1: `ui / primitives` (`零业务耦合的纯视觉交互原子`)

- **Scope**: Generic design-system building blocks (`Button`, `Input`, `Select`,
  `Dialog`, `Drawer`, `DataTable`, `Tabs`, `Badge`, `Tooltip`, `EmptyState`).
- **Hard Boundaries**:
  - **Zero domain knowledge**: Never import API clients, route queries, auth
    stores, or domain types (`Order`, `Contract`, `UserProfile`).
  - Communicate strictly via typed props, callbacks/events, and composition
    (`children` / named `slots` / snippets).
  - Support both controlled and uncontrolled usage cleanly where standard.

### Layer 2: `features / modules` (`业务领域复合模块`)

- **Scope**: Cohesive domain slices (`features/contracts/`, `features/billing/`)
  containing domain-specific composite components (`ContractFilterBar`,
  `ApprovalTimeline`), domain hooks/composables (`useContractList`), and local
  view-model mappers.
- **Hard Boundaries**:
  - **Ban deep Props Drilling (`禁止超过 2 层透传 Props`)**: Do not pass
    callbacks or state through 3–4 intermediate layout wrappers that do not use
    them. Flatten trees via **slot/children composition** first, or use a
    narrowly scoped feature Context (`createContext` / `provide-inject` / Svelte
    context) when siblings genuinely share complex domain state.
  - **Ban cross-feature internal imports**: Feature A may import from Feature
    B's explicit public barrel (`features/users/index.ts`) or promote truly
    shared domain widgets into `components/shared/`—never reach into another
    feature's private internals.

### Layer 3: `pages / views / app routes` (`纯路由编排壳层`)

- **Scope**: Route entrypoints (`app/contracts/page.tsx`,
  `views/ContractListView.vue`, `routes/contracts/+page.svelte`).
- **Hard Boundaries**:
  - Keep route files thin (**target ≤ 80–120 lines**): read route params & URL
    query state, wire top-level server/query orchestration, and compose
    `PageShell` + `features/*` sections.
  - Never dump 400 lines of raw form validation, table column definitions, and
    modal sub-trees directly inside a route file.

---

## 2. Component Complexity & Hygiene Guardrails (`单组件复杂度警戒线`)

1. **250-Line Complexity Ceiling (`250 行拆分红线`)**:
   - Whenever a single `.tsx` / `.vue` / `.svelte` component file exceeds
     **~250 lines** (or mixes > 2 orthogonal concerns such as filter state +
     inline edit modal + chart aggregation), split cohesive sub-sections into
     focused child files or extract non-visual logic into a dedicated
     hook/composable (`useContractActions.ts`).
2. **Zero Multi-Stateful Inline Subcomponents (`严禁单文件堆砌有状态内联子组件`)**:
   - **Never** declare a child component *inside* another component's render
     body (`function Parent() { function Child() { const [x] = useState() ... }
     }`)—every parent re-render destroys and remounts `Child`, wiping DOM focus
     and local state.
   - Do not cram 3–4 separate stateful components into a single file; give
     stateful subcomponents their own module or clean co-located file.
3. **Composition Over Boolean Prop Explosion (`组合优于布尔参数爆炸`)**:
   - Replace brittle flag matrices (`<Header showSearch hasCreateBtn isCompact
     withExport hideDivider />`) with explicit layout slots (`actions`,
     `filters`, `children`) and discriminated `variant` unions (`variant?:
     'default' | 'compact'`).

---

## 3. Four-Way State Taxonomy (`状态四分法：各归其位`)

Before creating any `useState` / `ref` / `$state` or store slice, classify the
data into **exactly one** of four buckets:

| State Category | Examples | Canonical Home | Hard Anti-Pattern (`严禁踩坑`) |
| :--- | :--- | :--- | :--- |
| **1. Server Cache State**<br>(`服务端异步数据态`) | Entity lists, detail records, permissions, dashboard metrics | TanStack Query / SWR / Next RSC / Nuxt `useAsyncData` / SvelteKit `load` | **Never** mirror API responses into Zustand/Pinia/Redux via manual `useEffect` / `onMounted` copy-paste |
| **2. URL Query State**<br>(`URL 路由同步态`) | Keyword `q`, filter enums, sort field/dir, `page` & `pageSize`, active `tab`, selected drawer ID | Router search params (`useSearchParams`, `useRoute`, `nuqs`, `$page.url`) | Storing table filters, pagination, or active tabs only in memory so pressing F5 or sharing a link resets the view |
| **3. Local UI State**<br>(`组件局部瞬时态`) | Popover open/close, input draft before blur/submit, hover/accordion toggle | Lowest common component (`useState` / `ref` / `$state`) | Hoisting ephemeral modal open flags or input keystrokes into a global store |
| **4. Minimal Global Store**<br>(`极简跨路由客户端态`) | Auth session summary, theme mode, sidebar collapsed pref, cross-route multi-step wizard draft | Lightweight store (`Zustand`, `Pinia`, Svelte module state, Context) | Treating the global store as a dumping ground for every page's API payload and form state |

### Derived State & Effect Discipline (`派生计算与副作用洁癖`)

- **Compute derived state during render**: Filter counts, `isAllSelected`,
  formatted totals, and permission flags MUST be computed synchronously (`const
  total = ...`, `computed()`, `$derived()`)—**never** chain `useEffect` /
  `watch` to write `setFilteredList(...)` from `list + query` (which causes
  double renders and stale-frame bugs).
- **Reserve effects strictly for external synchronization**: DOM imperative APIs
  (`dialog.showModal()`), subscriptions, timers, or non-framework libraries—always
  returning a deterministic cleanup function.

---

## 4. Unified API Layer & Strict TypeScript Contracts (`API 收口与类型安全边界`)

1. **Centralized Request Layer (`禁止组件内散写裸请求`)**:
   - UI components and pages MUST NOT call raw `fetch('/api/...')` with ad-hoc
     headers and `JSON.parse` inline. Route all calls through a shared API
     service layer (`services/` or `api/`) with unified base URL, auth headers,
     timeout budget, and response envelope parsing.
2. **Race-Condition & Cancellation Safety (`超时与竞态取消保护`)**:
   - Search inputs, filter changes, and tab switches firing async requests MUST
     pass `AbortSignal` (`AbortController`) or rely on query-key cancellation so
     a slow response from Query A never overwrites a fast response from Query B.
3. **Error Normalization — Zero Silent Swallowing (`错误归一化，严禁静默吞错`)**:
   - Normalize HTTP/network/business failures into a typed `AppError` (`code`,
     `message`, `status`, `fieldErrors?`, `retryable`).
   - **Strictly forbid** `catch (e) { console.log(e); return []; }`—never
     disguise a failed API request as an `Empty` list! Surface errors to the
     query/UI `Error` state or structured toast/form handler.
4. **Zero `any` & DTO-to-ViewModel Decoupling (`禁裸 any，解耦后端 DTO 与视图模型`)**:
   - Ban bare `any` (`unknown` + type guards or Zod/Valibot runtime parsing at
     external boundaries).
   - Model mutually exclusive async/UI states with **discriminated unions**
     (`type AsyncState<T> = { status: 'loading' } | { status: 'error'; error:
     AppError } | { status: 'ready'; data: T }`) rather than contradictory
     booleans.
   - Map raw backend **DTOs** (e.g., `snake_case`, nullable legacy codes, raw ISO
     strings, cent integers) into clean frontend **Domain / ViewModel types** in
     one boundary mapper—never leak backend field quirks across 15 UI components.
