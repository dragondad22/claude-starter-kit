# Staged kit modules

Dormant module payloads, staged here at inception by the kit's scaffold engine
so that later installs work offline and stay version-consistent with the kit
this project was scaffolded from. **Nothing under this directory is active
project content** — do not edit these copies or reference them from project
docs; the installed copy at its real path is the live one.

- See what's available and installed: `bash ai/scripts/scaffold-module.sh list`
- Install a module when its trigger fires: `bash ai/scripts/scaffold-module.sh <name>`

Modules are **offered** when a trigger fires (first schema/migration file,
first UI code, first formal QA/UAT need, first deploy target, team formation —
the table lives in the manifest staged alongside this file) — never silently
applied. Installs are recorded in `bootstrap/KIT_VERSION`, which also names the
kit version this project came from.

**Before installing a module that ships a standard**, check whether the repo
already has its own doc covering that role under another name (retrofit repos
often do — e.g. an existing SLA doc named differently). Installing anyway
creates two authorities for one topic; reconcile first — `git mv` or merge the
existing doc via `/conform` — rather than keeping both.
