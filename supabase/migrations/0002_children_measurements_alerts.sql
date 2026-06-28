-- Run after 0001_init_auth.sql, in the same SQL Editor.
-- Children, measurements and alerts tables + RLS, mirroring the local
-- drift tables in lib/data/local/app_database.dart.

create table if not exists public.children (
  id uuid primary key,
  name text not null,
  date_of_birth date not null,
  sex text not null check (sex in ('male', 'female')),
  birth_weight_kg numeric,
  parent_user_id uuid references public.users (id) on delete set null,
  registered_by_nurse_id uuid references public.users (id) on delete set null,
  -- Short human-typeable code (and QR payload) a parent uses to claim an
  -- unlinked child record — see ParentLinkChildScreen / ChildRepository.
  link_code text unique not null,
  -- Free-text phone/email the nurse jotted down for reference; this is NOT
  -- used to auto-link (RLS can't safely expose other users' contact info
  -- to look it up), linking always goes through link_code.
  parent_contact text,
  created_at timestamptz not null default now()
);

alter table public.children enable row level security;

create policy "Parents can read their own children"
  on public.children for select
  using (auth.uid() = parent_user_id);

create policy "Nurses can read children they registered"
  on public.children for select
  using (auth.uid() = registered_by_nurse_id);

-- Needed so a parent can look up an unlinked record by its link_code before
-- claiming it. Known limitation for this MVP: any signed-in user can read
-- any *unlinked* child row (name, DOB, sex) — acceptable for the Palier 1
-- demo scope, flagged here for the dissertation's limitations section.
create policy "Unlinked children are readable for code-based linking"
  on public.children for select
  using (parent_user_id is null);

create policy "Nurses can register children"
  on public.children for insert
  with check (auth.uid() = registered_by_nurse_id);

create policy "Parents can claim an unlinked child"
  on public.children for update
  using (parent_user_id is null)
  with check (auth.uid() = parent_user_id);

create table if not exists public.measurements (
  id uuid primary key,
  child_id uuid not null references public.children (id) on delete cascade,
  nurse_id uuid not null references public.users (id),
  taken_at timestamptz not null default now(),
  weight_kg numeric not null,
  height_cm numeric not null,
  muac_cm numeric,
  head_circumference_cm numeric,
  bmi numeric,
  waz numeric,
  haz numeric,
  whz numeric,
  created_at timestamptz not null default now()
);

alter table public.measurements enable row level security;

create policy "Measurements are readable by the child's parent or nurse"
  on public.measurements for select
  using (
    exists (
      select 1 from public.children c
      where c.id = measurements.child_id
        and (c.parent_user_id = auth.uid() or c.registered_by_nurse_id = auth.uid())
    )
  );

create policy "Nurses can record measurements for children they registered"
  on public.measurements for insert
  with check (
    auth.uid() = nurse_id
    and exists (
      select 1 from public.children c
      where c.id = measurements.child_id
        and c.registered_by_nurse_id = auth.uid()
    )
  );

create table if not exists public.alerts (
  id uuid primary key,
  child_id uuid not null references public.children (id) on delete cascade,
  level text not null check (level in ('moderate', 'severe')),
  message text not null,
  created_at timestamptz not null default now(),
  resolved boolean not null default false
);

alter table public.alerts enable row level security;

create policy "Alerts are readable by the child's parent or nurse"
  on public.alerts for select
  using (
    exists (
      select 1 from public.children c
      where c.id = alerts.child_id
        and (c.parent_user_id = auth.uid() or c.registered_by_nurse_id = auth.uid())
    )
  );

create policy "Nurses can create and resolve alerts for their children"
  on public.alerts for insert
  with check (
    exists (
      select 1 from public.children c
      where c.id = alerts.child_id
        and c.registered_by_nurse_id = auth.uid()
    )
  );

create policy "Nurses can resolve alerts for their children"
  on public.alerts for update
  using (
    exists (
      select 1 from public.children c
      where c.id = alerts.child_id
        and c.registered_by_nurse_id = auth.uid()
    )
  );
