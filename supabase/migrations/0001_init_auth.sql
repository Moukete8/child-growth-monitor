-- Run this once in the Supabase dashboard: Project > SQL Editor > New query.
-- Sets up the public.users profile table (role, full name, etc.) that mirrors
-- the local `users` drift table, plus the trigger that creates a profile row
-- automatically whenever someone signs up via Supabase Auth.

create table if not exists public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  role text not null check (role in ('parent', 'nurse')),
  full_name text not null,
  email text,
  phone text,
  hospital_id text,
  created_at timestamptz not null default now()
);

alter table public.users enable row level security;

create policy "Users can read own profile"
  on public.users for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on public.users for update
  using (auth.uid() = id);

-- Populates public.users from the metadata passed to supabase.auth.signUp(),
-- so the Flutter app never needs the service-role key to create the profile row.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.users (id, role, full_name, email, phone, hospital_id)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'role', 'parent'),
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    new.email,
    new.raw_user_meta_data ->> 'phone',
    new.raw_user_meta_data ->> 'hospital_id'
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
