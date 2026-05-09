# Supabase Database Design for CollabTask

## Overview
This repository uses **Supabase** (PostgreSQL + Realtime) as the backend. The database schema and Row‑Level Security policies are described in detail below. The file also contains quick‑reference SQL for **migrations**, **seeding**, and **real‑time** setup.

---

## 1.  Tables & Relationships

| Table | Columns | Notes | Foreign Keys | Junctions |
|-------|---------|-------|--------------|-----------|
| `profiles` | `id` (PK), `email`, `display_name`, `avatar_url`, `phone_number`, `created_at`, `updated_at` | Stores app‑specific user data. Linked one‑to‑one with `auth.users`. | `id` → `auth.users(id)` | — |
| `workspaces` | `id` (PK), `name`, `description`, `owner_id`, `created_at`, `updated_at` | A *team* or *project*. | `owner_id` → `profiles(id)` | — |
| `workspace_members` | `id` (PK), `workspace_id`, `user_id`, `role`, `joined_at` | N:M between workspaces & users. | `workspace_id` → `workspaces(id)` <br> `user_id` → `profiles(id)` | — |
| `tasks` | `id` (PK), `workspace_id`, `title`, `description`, `status`, `due_date`, `created_by`, `created_at`, `updated_at`, `checklist` (JSONB) | Core entity. Checklist stored as JSON array. | `workspace_id` → `workspaces(id)` | `task_assignees` (N:M) |
| `task_assignees` | `id` (PK), `task_id`, `user_id` | Assigns users to a task. | `task_id` → `tasks(id)` <br> `user_id` → `profiles(id)` | — |
| `labels` | `id` (PK), `workspace_id`, `name`, `color` | Re‑usable labels per workspace. | `workspace_id` → `workspaces(id)` | `task_labels` |
| `task_labels` | `id` (PK), `task_id`, `label_id` | Many‑to‑many between tasks & labels. | `task_id` → `tasks(id)` <br> `label_id` → `labels(id)` | — |
| `messages` | `id` (PK), `task_id`, `user_id`, `text`, `created_at`, `updated_at`, `deleted_at` | Chat per task. | `task_id` → `tasks(id)` <br> `user_id` → `profiles(id)` | — |

### Checklist as JSONB
```
[{
  "id": "check_1",
  "title": "Wireframes",
  "completed": true
},{
  "id": "check_2",
  "title": "Color palette",
  "completed": false
}]
```

---

## 2.  Migrations

All migration files are version stamped (YYYYMMDD_HHMMSS). Place them in `supabase/migrations/`.

### Sample migration: `20240605_120000_create_tables.sql`
```sql
-- Profiles trigger (auto‑create profile on auth.users insert)
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Profiles table
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT,
  display_name TEXT,
  avatar_url TEXT,
  phone_number TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ... (rest of tables defined as in the Overview) ...
```

Run the migrations with:
```bash
supabase db push
```

---

## 3.  Row‑Level Security (RLS)

RLS policies are defined per table in the same migration file. Example snippet for `tasks`:
```sql
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Workspace members can read tasks"
  ON public.tasks FOR SELECT
  USING (
    workspace_id IN (
      SELECT workspace_id FROM public.workspace_members WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Workspace members can create/update/delete tasks"
  ON public.tasks FOR INSERT, UPDATE, DELETE
  USING (
    workspace_id IN (
      SELECT workspace_id FROM public.workspace_members WHERE user_id = auth.uid()
    )
  );
```

Apply RLS to other tables in a similar fashion.

---

## 4.  Real‑time Subscriptions

All tables that are part of the collaborative experience (tasks, messages, workspace_members, task_assignees) have **Realtime** enabled. In the Supabase Dashboard → **Real‑time** → toggle the tables.

On the client side use Supabase's `channel(...).onPostgresChanges(...)` API.

---

## 5.  Seeding Sample Data

Place seed scripts under `supabase/migrations/` or use the Supabase Dashboard directly.

Example seed script: `20240605_120100_seed_demo.sql`
```sql
-- Create workspace
INSERT INTO public.workspaces (id, name, owner_id, created_at)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'Demo Workspace',
  (SELECT id FROM auth.users LIMIT 1),
  NOW()
);

-- Add current user as workspace member
INSERT INTO public.workspace_members (id, workspace_id, user_id, role)
VALUES (
  '00000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000001',
  (SELECT id FROM auth.users LIMIT 1),
  'admin'
);

-- Insert a sample task
INSERT INTO public.tasks (id, workspace_id, title, description, status, checklist)
VALUES (
  '00000000-0000-0000-0000-000000000003',
  '00000000-0000-0000-0000-000000000001',
  'Set up Supabase',
  'Create tables, policies, and seed data',
  'todo',
  '[]'::jsonb
);
```

Run:
```bash
supabase db push
```

---

## 6.  Flutter Integration Quick‑Start

1. **Environment** – Add Supabase URL & anon key to `.env` (git‑ignored).
   ```dotenv
   SUPABASE_URL=https://xxxx.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJ...
   ```
2. **Initialize** in `main_common.dart`:
   ```dart
   await Supabase.initialize(
     url: dotenv.env['SUPABASE_URL']!,
     anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
   );
   ```
3. **Use SupabaseClient** anywhere: `Supabase.instance.client`.
4. **Auth** – Replace custom auth with `SupabaseAuthClient` methods (sign‑in, sign‑up, sign‑out). Store the user session automatically.
5. **Data Layer** – `TaskDatasourceSupabase` uses `client.from('tasks').select()…` instead of `ApiHelper`.
6. **Realtime** – Use `client.channel('public:tasks').onPostgresChanges(...)` for real‑time updates.

---

## 7.  Migration Checklist

| Step | Action | Done? |
|------|--------|-------|
| 1 | Run `supabase init` → create `supabase` directory | ✅ |
| 2 | Add migration files → run `supabase db push` | ✅ |
| 3 | Enable Realtime on tables | ✅ |
| 4 | Add `.env` & initialize Supabase in Flutter | ✅ |
| 5 | Replace auth flow | ⬜ |
| 6 | Replace datasource with Supabase version | ⬜ |
| 7 | Wire up real‑time subscriptions | ⬜ |
| 8 | Write tests for using Supabase client | ⬜ |
| 9 | Seed demo data | ⬜ |
|10 | Run `flutter analyze` and `flutter test` | ⬜ |

Feel free to refer to this file throughout development to keep a consistent schema and to troubleshoot policy or schema mismatches.

---

> **Tip:** Whenever you add a new column or table, add a new migration and run `supabase db push`. Do **not** edit the schema file directly; migrations keep a history.
