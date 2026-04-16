-- AI Panel — Supabase schema
-- Run this once in your Supabase project SQL Editor.
-- Auth is handled by Supabase (magic-link email sign-in is enabled by default).

-- ---------- Tables ----------

create table if not exists public.projects (
  id          text primary key,                 -- client-generated: "p0", "p<timestamp>"
  user_id     uuid not null references auth.users(id) on delete cascade,
  name        text not null,
  color       text not null,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

create table if not exists public.conversations (
  id          text primary key,                 -- client-generated: "c<timestamp>"
  user_id     uuid not null references auth.users(id) on delete cascade,
  project_id  text not null references public.projects(id) on delete cascade,
  title       text,
  turns       jsonb not null default '[]'::jsonb,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

create table if not exists public.shared_links (
  id          text primary key,                 -- short slug
  user_id     uuid references auth.users(id) on delete set null,
  title       text,
  turns       jsonb not null default '[]'::jsonb,
  created_at  timestamptz default now()
);

create table if not exists public.user_settings (
  user_id     uuid primary key references auth.users(id) on delete cascade,
  api_keys    jsonb not null default '{}'::jsonb,
  updated_at  timestamptz default now()
);

create index if not exists conversations_user_idx   on public.conversations(user_id);
create index if not exists conversations_proj_idx   on public.conversations(project_id);
create index if not exists projects_user_idx        on public.projects(user_id);

-- ---------- Row Level Security ----------

alter table public.projects       enable row level security;
alter table public.conversations  enable row level security;
alter table public.shared_links   enable row level security;
alter table public.user_settings  enable row level security;

-- Projects: owner-only
drop policy if exists "projects_select_own"  on public.projects;
drop policy if exists "projects_insert_own"  on public.projects;
drop policy if exists "projects_update_own"  on public.projects;
drop policy if exists "projects_delete_own"  on public.projects;

create policy "projects_select_own"  on public.projects for select  using  (auth.uid() = user_id);
create policy "projects_insert_own"  on public.projects for insert  with check (auth.uid() = user_id);
create policy "projects_update_own"  on public.projects for update  using  (auth.uid() = user_id);
create policy "projects_delete_own"  on public.projects for delete  using  (auth.uid() = user_id);

-- Conversations: owner-only
drop policy if exists "conv_select_own"  on public.conversations;
drop policy if exists "conv_insert_own"  on public.conversations;
drop policy if exists "conv_update_own"  on public.conversations;
drop policy if exists "conv_delete_own"  on public.conversations;

create policy "conv_select_own"  on public.conversations for select  using  (auth.uid() = user_id);
create policy "conv_insert_own"  on public.conversations for insert  with check (auth.uid() = user_id);
create policy "conv_update_own"  on public.conversations for update  using  (auth.uid() = user_id);
create policy "conv_delete_own"  on public.conversations for delete  using  (auth.uid() = user_id);

-- Shared links: public read, author insert/delete
drop policy if exists "shared_select_public" on public.shared_links;
drop policy if exists "shared_insert_own"    on public.shared_links;
drop policy if exists "shared_delete_own"    on public.shared_links;

create policy "shared_select_public" on public.shared_links for select using (true);
create policy "shared_insert_own"    on public.shared_links for insert with check (auth.uid() = user_id);
create policy "shared_delete_own"    on public.shared_links for delete using (auth.uid() = user_id);

-- User settings: owner-only
drop policy if exists "settings_select_own" on public.user_settings;
drop policy if exists "settings_insert_own" on public.user_settings;
drop policy if exists "settings_update_own" on public.user_settings;

create policy "settings_select_own" on public.user_settings for select using (auth.uid() = user_id);
create policy "settings_insert_own" on public.user_settings for insert with check (auth.uid() = user_id);
create policy "settings_update_own" on public.user_settings for update using (auth.uid() = user_id);

-- ---------- Auth redirect URLs ----------
-- In Supabase Dashboard → Authentication → URL configuration, add:
--   Site URL:            https://hippolyterechard10-blip.github.io/Click-AI/
--   Redirect URLs:       https://hippolyterechard10-blip.github.io/Click-AI/
