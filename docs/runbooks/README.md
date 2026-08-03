# runbooks

Operational how-tos: step-by-step procedures for running, inspecting, and recovering
this system. Belongs here:

- **Where do I find errors?** — log locations per environment, how to filter by
  request/correlation id, what a typical failure trail looks like (the logging
  standard asks for this one; see `ai/STANDARDS/LOGGING_STANDARD.md`).
- Deploy/rollback procedures (arrive with the deploy-ci module).
- Backup/restore procedures, incident recovery steps, scheduled-maintenance tasks.

One file per procedure, named for the question it answers
(e.g. `where-do-i-find-errors.md`, `restore-from-backup.md`).
