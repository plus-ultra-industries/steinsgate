# DARK_FACTORY_PLAN.md

## Vision
Build a prompt-native, GitHub Actions-based "Dark Factory" where agents behave like a software team and execute software delivery from issue to PR with minimal glue code.

## Non-Negotiables (from Mi loco)
1. Keep architecture simple: prompts + workflows.
2. Avoid script baggage unless absolutely necessary.
3. Use coding agents directly (Codex/Claude), not custom API orchestration.
4. Iterate fast, with visible commits and run-level validation.
5. Start with one workflow and prove it works end-to-end.

## Current State (as of now)
- All background self-check cron jobs are disabled.
- Most old workflows are disabled; currently focused on `engineer-codex.yml`.
- `engineer-codex.yml` was reduced to a minimal dispatch sanity baseline and verified to run successfully.
- Existing repo artifacts still include older bootstrap/task files and prompts from prior iterations.

## Lessons Learned
1. Workflow validity must be proven before adding logic.
2. Push-trigger failures with no logs often indicate YAML/validation-level issues.
3. Avoid adding multiple workflows simultaneously while baseline is unstable.
4. Use tiny increments: one added capability per commit + run verification.

## Target v1 (Single Workflow First)
One workflow (`Engineer Codex`) should:
1. Accept an issue number via workflow_dispatch.
2. Fetch issue title/body.
3. Run codex to implement issue on a branch.
4. Commit + push branch.
5. Open PR automatically.
6. Comment back on issue with PR URL.

If this works reliably, then add label trigger (`implement`) as step 2.

## Immediate Action Plan (Execution Order)

### Phase A — Stabilize Single Workflow (NOW)
1. Keep `engineer-codex.yml` minimal and valid.
2. Add `issue_number` input only.
3. Add "fetch issue context" step only.
4. Run dispatch and verify success.

### Phase B — Add Codex Execution
5. Add codex availability check (`command -v codex`).
6. Add codex run step with issue context prompt.
7. Dispatch run and inspect logs.
8. If codex missing, fail loudly with clear message (no silent fallback).

### Phase C — Git Operations
9. Add branch creation + commit + push steps.
10. Add PR creation step (`gh pr create`).
11. Add issue comment with PR link.
12. Dispatch and verify end-to-end success.

### Phase D — Trigger Convenience
13. Add issues:labeled trigger (`implement`) once dispatch flow is stable.
14. Validate both manual and label-triggered paths.

## Definition of Done (for this stage)
- A manually created issue can be implemented by triggering `Engineer Codex`.
- A PR is created with real code changes (or explicit codex failure message).
- Issue gets a completion comment with PR link.
- Workflow passes consistently across two consecutive runs.

## What Comes After
Only after single-workflow success:
- Add Reviewer stage.
- Add QA stage.
- Add merge gate labels/checks.
- Then port stable patterns back to `darkforge`.
