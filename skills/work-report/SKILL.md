---
name: work-report
description: >-
  One-screen code change walkthrough with candid trade-offs and real test
  status. Triggers: /work-report, "work report", "walk me through the changes",
  "brief me on the changes", "工作汇报", "向我汇报", "汇报一下这次改动".
license: MIT
metadata:
  author: ainward
  version: "2.1.0"
---

# Work Report (改动交底与走读)

Deliver a **clear, honest, one-screen peer-engineer walkthrough** of completed
or modified code—grouping changes functionally, linking straight to touched
code, and surfacing shortcuts, assumptions, and unrun checks upfront with zero
modal popups.

## When to use & boundary

- On-demand handoff walkthrough after features, fixes, or refactors have been
  implemented in the current session, working tree, or specified commits/branches.
- Focus strictly on **what changed, why, intentional trade-offs/shortcuts, and
  observed verification**—never run self-biased 3D call-chain regression audits
  (leave independent bug hunting to `/agent-review`).
- Stay fast and read-only by default: do not trigger unprompted slow test suites,
  write summary files to disk, or run `git commit` / `git push` unless instructed.

## Workflow

### Step 1: Anchor Scope & Group by Feature

1. **Smart Scope Resolution** *(in priority order)*:
   - **Explicit scope**: paths, modules, commits, or branch ranges named by the user.
   - **Session-anchored changes**: files created, modified, or deleted in **this
     conversation** *(ignore unrelated dirty files from parallel work, adding at
     most a 1-line exclusion note)*.
   - **Workspace / HEAD fallback**: uncommitted diffs (`git status` / `git diff`),
     falling back to `git show --stat HEAD` & `git show HEAD` when clean.
2. **Cohesive Functional Grouping (`#1..#N`)**:
   - Group by **feature or module boundary** (core logic first, supporting
     wiring/types/config/tests after)—never split mechanically file by file.
   - Keep `N = 1` for a single focused fix.

### Step 2: Deliver the One-Screen Walkthrough (Zero Modal Popups)

Format every file reference as a **compact clickable basename link**
(`[orderService.ts](file:///abs/path/orderService.ts#L42-L58)` when supported;
`path/orderService.ts:42-58` plain fallback; ban raw full-path walls and
class/symbol inventories). Reply in the user's language and stop cleanly
**without** calling `ask_question` or appending scripted footers:

1. **改动总括 (Headline, 1–2 lines)**: completion status, module/file count
   (`共 N 块 / X 个文件`), overall verification summary, and a brief `⚠️` count
   if any shortcuts or unverified items exist.

2. **分组改动说明 (`#1..#N`)**:
   - **Header**: `#k <Plain-Language Functional Title>` —
     `[fileA.ts](file:///abs/path/fileA.ts#L10-L34), [fileB.ts](file:///abs/path/fileB.ts#L5-L18)`
   - **改了什么**: 1–3 plain sentences explaining functional before-vs-after behavior.
   - **⚠️ 取舍与假设**: include **only** when a design compromise, hardcoded
     fallback, temporary workaround, or implicit assumption exists—state it
     candidly **once** right here (never disguise shortcuts as ideal design;
     omit this line completely when clean).
   - **验证情况**: report strictly from observed runs (`Ran: pnpm test auth — passed`
     / `tsc --noEmit 通过`), or mark candidly as `Not verified: <reason>` (`未验证：<原因>`).
   - *(Compress minor wiring/types/config groups into 1 tight line:
     `#k [配套] <summary> ([types.ts](file:///...#L...)) — <verification>`.)*

*(Switch to sequential 1-by-1 paging only if the user explicitly asks to walk
through items one at a time; on follow-up edit requests, modify the target code
directly and run fast targeted checks.)*
