# 🚀 CollabTask: Supabase Implementation Prompt

Use this prompt to set up your Supabase backend to match the Flutter app perfectly.

---

## The Prompt

### 1. Project Overview
I am building **CollabTask**, a real-time collaborative workspace. I want to use **Supabase** as my backend.

### 2. Database Schema (PostgreSQL)
Please generate the SQL to create the following tables in Supabase:

- **profiles**: `id` (references auth.users), `name`, `avatar_url`.
- **tasks**: 
    - `id` (uuid, primary key)
    - `title` (text)
    - `description` (text)
    - `status` (enum: 'todo', 'inProgress', 'done')
    - `due_date` (timestamptz)
    - `labels` (text array)
    - `created_at`, `updated_at` (timestamptz)
- **task_assignees**: Join table between `tasks` and `profiles`.
- **checklist_items**:
    - `id` (uuid)
    - `task_id` (references tasks.id)
    - `title` (text)
    - `completed` (boolean)
- **messages**:
    - `id` (uuid)
    - `task_id` (references tasks.id)
    - `user_id` (references profiles.id)
    - `text` (text)
    - `created_at`

### 3. Real-time Requirements
Enable **Supabase Realtime** (Replication) on the `tasks`, `checklist_items`, and `messages` tables so the Flutter app can listen for changes via WebSockets.

### 4. Row Level Security (RLS)
Generate RLS policies so that:
- Users can only see tasks in workspaces they belong to.
- Any authenticated user can create a task.
- Only assignees or creators can delete a task.

### 5. Flutter Integration Advice
Provide the code snippets for:
- Initializing the Supabase client in Flutter.
- Setting up a `stream()` on the `tasks` table to drive the Kanban board.
- Performing a `batch` update for reordering tasks.

---

## 💡 How to use this with CollabTask

1.  **Paste into AI**: Use the prompt above.
2.  **Supabase Console**: Go to the "SQL Editor" in your Supabase dashboard and paste the generated SQL.
3.  **App Config**:
    - Get your `SUPABASE_URL` and `SUPABASE_ANON_KEY` from settings.
    - In your Flutter app, add the `supabase_flutter` package.
    - Initialize it in `main_common.dart`.
