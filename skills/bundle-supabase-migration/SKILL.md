---
name: bundle-supabase-migration
description: "Use for any Bundle Events database change beyond a new snapshot JSON key: tables, columns, functions or policies."
---

# Bundle supabase migration

Read docs/database/schema.md and src/lib/supabase/server.ts. For a new key
inside the trip JSON, use `bundle-snapshot-field` instead.

Write the SQL in a new file `supabase/migrations/<YYYYMMDDHHMMSS>_<name>.sql`,
safe to run twice with `if not exists` and `create or replace`. The doc names
an api_cache migration that is not committed on `dev`, and an open PR uses
another naming scheme. Use the timestamp format and mention the inconsistency
in the PR rather than fixing it silently.

Enable RLS with no policy on every new table. For each new function, in the
same migration, run `revoke all on function ... from public, anon,
authenticated;` and then `grant execute on function ... to service_role;`. A
grant alone leaves PostgreSQL's default `PUBLIC` execute in place. The browser
never talks to Supabase. Access goes through `getSupabaseAdmin()` in route
handlers.

Handle the table or column being absent, since a teammate or a preview may run
before the SQL is applied. The API cache already degrades to memory only in
that case, so follow its example. Update the tables in docs/database/schema.md
in the same change.

State in the PR that someone must run the SQL in the Supabase SQL editor
before or with the deploy, and list it for `bundle-release`. Never run SQL
against the production project yourself, and never put the service-role key in
a file or a log.
