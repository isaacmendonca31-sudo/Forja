-- FORJA 0.5.0 — Execute no SQL Editor do Supabase.
-- Uma linha por usuário. Row Level Security impede acesso aos dados de outras contas.
create table if not exists public.forja_user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  workouts jsonb not null default '[]'::jsonb,
  active_session jsonb null,
  active_session_updated_at timestamptz not null default now(),
  dismissed_recommendations jsonb not null default '[]'::jsonb,
  deleted_workout_ids jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now(),
  constraint forja_workouts_is_array check (jsonb_typeof(workouts) = 'array'),
  constraint forja_dismissed_is_array check (jsonb_typeof(dismissed_recommendations) = 'array'),
  constraint forja_deleted_ids_is_array check (jsonb_typeof(deleted_workout_ids) = 'array')
);

alter table public.forja_user_data enable row level security;

-- Usuário só pode ler sua própria linha.
drop policy if exists "Users can read their own FORJA data" on public.forja_user_data;
create policy "Users can read their own FORJA data"
  on public.forja_user_data for select to authenticated
  using (auth.uid() = user_id);

-- Usuário só pode inserir dados vinculados ao próprio UID.
drop policy if exists "Users can insert their own FORJA data" on public.forja_user_data;
create policy "Users can insert their own FORJA data"
  on public.forja_user_data for insert to authenticated
  with check (auth.uid() = user_id);

-- Usuário só pode atualizar sua própria linha e não pode trocar o proprietário.
drop policy if exists "Users can update their own FORJA data" on public.forja_user_data;
create policy "Users can update their own FORJA data"
  on public.forja_user_data for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

revoke all on public.forja_user_data from anon, authenticated;
grant select, insert, update on public.forja_user_data to authenticated;
