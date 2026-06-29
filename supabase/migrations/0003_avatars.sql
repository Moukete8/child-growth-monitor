-- Run after 0001_init_auth.sql and 0002_children_measurements_alerts.sql,
-- in the same SQL Editor.
-- Adds avatar_url to users/children, a public "avatars" storage bucket, and
-- the policies needed for: a nurse to set a child's avatar once at
-- registration (insert), and the linked parent to change it afterwards
-- (update) — without giving the parent write access to the rest of the
-- child's record (name, DOB, sex stay nurse-only after creation).

alter table public.users add column if not exists avatar_url text;
alter table public.children add column if not exists avatar_url text;

-- Public bucket: avatar URLs are unguessable (UUID-keyed paths) and hold no
-- other PII, so a public bucket avoids signed-URL refresh complexity for
-- this MVP. Documented as a known limitation in the dissertation.
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- Anyone signed in may upload into their own folder ({auth.uid()}/...).
-- A child has no auth identity, so both the registering nurse and the
-- linked parent upload child avatars under their own uid, e.g.
-- "{uid}/child-{child_id}.jpg" — avatar_url just points at whichever
-- upload is the current one.
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

-- Children: lets the linked parent update avatar_url after the nurse's
-- initial registration. RLS is row-level only — it can't restrict *which*
-- column a parent changes via this policy, so the trust boundary here is
-- the Flutter client itself, which only ever sends {'avatar_url': ...} in
-- this update path (ChildRepository.updateChildAvatarAsParent). A
-- column-level GRANT was deliberately avoided: it would also gate the
-- ON CONFLICT DO UPDATE half of ChildRepository.pushPendingChildren's
-- upsert (used to retry a nurse's offline child registration), which needs
-- to write every column, not just avatar_url. Flagged as a known MVP
-- limitation for the dissertation, same spirit as the unlinked-children
-- read policy above.
create policy "Parents can update their linked child's avatar"
  on public.children for update
  using (parent_user_id = auth.uid())
  with check (parent_user_id = auth.uid());
