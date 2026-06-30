-- Idempotent repair: re-creates the avatars bucket + storage.objects
-- policies from scratch, regardless of partial/duplicate state left by
-- earlier manual re-runs of 0003_avatars.sql (CREATE POLICY has no
-- IF NOT EXISTS/ON CONFLICT equivalent, so a re-run can fail partway
-- and leave some policies missing or stale).
-- Safe to run any number of times.

insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do update set public = true;

drop policy if exists "Users can upload into their own avatar folder" on storage.objects;
drop policy if exists "Users can replace files in their own avatar folder" on storage.objects;

create policy "Users can upload into their own avatar folder"
  on storage.objects for insert
  with check (
    bucket_id = 'avatars'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "Users can replace files in their own avatar folder"
  on storage.objects for update
  using (
    bucket_id = 'avatars'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

drop policy if exists "Parents can update their linked child's avatar" on public.children;
create policy "Parents can update their linked child's avatar"
  on public.children for update
  using (parent_user_id = auth.uid())
  with check (parent_user_id = auth.uid());
