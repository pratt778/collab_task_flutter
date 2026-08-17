# Lessons Learned: CollabTask Development

This document tracks technical hurdles, RLS policy traps, and architectural solutions encountered during the development of CollabTask.

## 1. Supabase RLS & Infinite Recursion
*   **The Problem:** When implementing RLS, we encountered `infinite recursion detected in policy` errors. This occurs when an RLS policy for Table A queries Table B, and the policy for Table B (directly or indirectly) references Table A.
*   **The Lesson:** Avoid circular dependencies in RLS. Never make an RLS policy for a table that queries the same table or another table that references the current one.
*   **The Solution (Non-Recursive Pattern):**
    *   For `workspaces`: Policy uses `owner_id = auth.uid()` OR queries a *lookup table* (`workspace_members`) using only the `auth.uid()`.
    *   For `workspace_members`: Policy only checks `user_id = auth.uid()`. It **must not** query the `workspaces` table to verify membership, as this creates the loop.

## 2. Workspace Duplication on Restart
*   **The Problem:** Workspaces and tasks seemed to "vanish" after every hot restart, causing the app to auto-generate a new "Personal Workspace".
*   **The Lesson:** Redundant creation logic is dangerous.
*   **The Solution:**
    1.  Ensure RLS policies correctly allow users to `SELECT` their existing records so the app *finds* them instead of thinking they don't exist.
    2.  Add a check in the `WorkspaceCubit` to query the list of existing workspaces before defaulting to `createDefaultWorkspace()`.

## 3. Localization Best Practices
*   **The Problem:** Hardcoded strings lead to maintainability issues and difficult translation workflows.
*   **The Lesson:** Early adoption of `gen-l10n` and proper `arb` file organization is essential.
*   **The Fix:** Use `flutter gen-l10n` and ensure `AppLocalizations.of(context)` is used for all UI strings. Avoid hardcoding strings in the UI layer.

## 4. Theme Integration
*   **The Problem:** Hardcoded colors (`Colors.white`, `AppColors.textDark`) lead to "theme breakage" in dark mode.
*   **The Lesson:** Use `ThemeExtension` to provide semantic color tokens (e.g., `context.appColors.surface` instead of `Colors.white`).
*   **The Solution:** Build a robust `AppColorsExtension` that defines semantic tokens for light and dark modes, then migrate all UI components to use these tokens.

## 5. RLS Deletion & Cascading Failures
*   **The Problem:** Workspace deletion seemed successful in the app but failed to remove data from Supabase, or caused failures because cascading operations on related tables were blocked.
*   **The Lesson:** Deletion operations are just as subject to RLS as Select/Insert operations. If a table has a foreign key constraint with `ON DELETE CASCADE`, the RLS policy must explicitly allow the user to delete records in the *referenced* tables.
*   **The Solution:** Ensure there are specific `DELETE` policies on all tables involved in the cascade (e.g., `workspace_members`) that allow owners to perform the deletion.
