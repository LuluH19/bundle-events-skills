---
name: bundle-supabase-migration
description: Add or change a Supabase table, column, function or policy for Bundle Events with a committed migration. Use for any database change beyond a new snapshot JSON key.
---

# Bundle supabase migration

Read docs/database/schema.md and src/lib/supabase/server.ts. For a new key inside the trip JSON, use `bundle-snapshot-field` instead.

1. Write the SQL in a new file `supabase/migrations/<YYYYMMDDHHMMSS>_<name>.sql`. Make it safe to run twice (`if not exists`, `create or replace`). The doc names an api_cache migration that is not committed on `dev`, and an open PR uses another naming scheme. Use the timestamp format and mention the inconsistency in the PR rather than fixing it silently.
2. Security: enable RLS with no policy on every new table, and grant new functions to `service_role` only, as the existing tables do. The browser never talks to Supabase. Access goes through `getSupabaseAdmin()` in route handlers.
3. Code: handle the table or column being absent, since a teammate or a preview may run before the SQL is applied. The API cache already degrades to memory-only in that case. Follow that example.
4. Docs: update the tables in docs/database/schema.md in the same change.
5. PR: state that someone must run the SQL in the Supabase SQL editor before or with the deploy, and list it for `bundle-release`.

Never run SQL against the production project yourself. Never put the service-role key in a file or a log.
