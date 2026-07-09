*Generic standard from the Claude starter kit — adapt to this project's stack. Replace `{{TOKENS}}`; see `bootstrap/PLACEHOLDERS.md`.*

# Documentation Standard

How user-facing documentation is written and **kept current**. Read before adding
or changing any user-facing page, surface, or help text.

## The one rule that cannot be broken

**User-facing documentation has a single source of truth, and every user-visible
change ships with its documentation update in the *same* PR.** Everything below is
in service of that rule. If you take nothing else from this file: when behavior a
user can see or do changes, the docs that describe it change in the same change-set,
reviewed together, merged together.

Purely internal changes (refactors, tests, infra with no user-visible impact) are
exempt.

## What counts as "user-visible"

A change is user-visible — and therefore needs docs — if a user could notice it:

- a new or changed screen, page, route, command, or flag;
- a new or changed field, option, control, or default;
- a change to what an action does, what it affects, or its side effects;
- a change to wording the user reads, terminology, or error messages;
- a new or removed capability, or a change to who can do what (roles/permissions).

If you are unsure, treat it as user-visible. Over-documenting a non-event is cheap;
shipping a silent behavior change is the expensive mistake.

## Source of truth

Pick **one** authoritative home for user-facing documentation and name it here:

> **Source of truth for this project:** `{{DOCS_SOURCE_OF_TRUTH}}`
> (e.g. a `docs/` site, a wiki, a README section, a generated reference). Fill this
> in during bootstrap.

Whatever you choose, the rule is the same: there is exactly one canonical place a
fact about user-facing behavior lives. Anything else (in-app strings, marketing
copy, support macros) either *transcludes* from that source or is explicitly
secondary. Two hand-maintained copies of the same fact will drift; do not create
them.

## Optional pattern: dual-surface documentation

Larger products benefit from **two surfaces over one source of truth**. This is an
**optional** pattern — adopt it only if your project has enough user-facing surface
to justify it:

1. **Reference manual / long form** — beginner-level, example-rich, one page per
   screen or command plus task tutorials. Lives in `{{DOCS_SOURCE_OF_TRUTH}}`.
2. **In-app / inline help** — short, contextual help shown next to the thing it
   explains (a help panel, per-page help, inline `?` field tooltips, `--help`
   output, hover text).

The discipline that makes this work: the **short help content is the single source
of truth for the short strings**, and the long-form manual *generates* or
*transcludes* those strings rather than re-typing them. The two surfaces cannot
drift because one is derived from the other. Keep the short-help content as plain
data (no UI-framework imports) so a build step can read it into the manual.

If you adopt this pattern, add a **gate** (a test or CI check) that fails when a
documentable surface has no help entry. A green build is the only reliable enforcer;
reviewer goodwill is not.

## Writing for beginners

- Assume no prior knowledge. Define terms the first time they appear —
  `docs/GLOSSARY.md` is the canonical source for what a term means here.
- Sentence case for headings and UI references; match the in-app label exactly.
- Prefer numbered steps for tasks; one action per step.
- Note role differences ("Admins can also…") where access varies.
- Add a screenshot or example when a visual removes ambiguity (a screen's layout, a
  wizard step, where a control is). Do not screenshot or quote trivial text.

## When to add an inline / field-level tooltip

Inline help (a `?` bubble next to a control, hover text, an example beside a flag)
is the cheapest place to remove confusion — it sits right next to the thing, so the
reader never leaves the page. The test for adding one: **would a non-expert user who
is not steeped in {{PROJECT_DOMAIN}} jargon hesitate at this field?** If yes, add
one. Concretely, add inline help when the label:

- uses a term of art or domain jargon;
- offers options whose consequences aren't obvious from their names (what does
  "Manual only" turn off? what happens next?);
- takes a format or unit that isn't self-evident (minutes vs. hours, a date format,
  an external ID shape);
- has a non-obvious side effect, default, or interaction with another setting.

Skip it when the label is self-explanatory to anyone (Name, Email, Search). Not
every field needs one — over-tooltipping trains people to ignore them. When in
doubt, picture a first-week user, not the person who built the screen.

Copy rules: one or two sentences, sentence case, plain language, no domain or
engineering jargon (or define it inline). Say what the field does **and** what the
non-obvious choice means (e.g. "…Choose *Manual only* to turn off automatic syncing
and sync on demand with the *Sync now* button…").

Inline help text should live in the **source of truth**, never hard-coded inline in
the component, so the same wording also lands in the manual.

## OS-agnostic instructions (mandatory)

Write instructions and commands so they work on **any operating system unless a step
is inherently OS-specific** — and when it is, label it. A reader on Windows, macOS,
or Linux should be able to follow any doc without translating it in their head.

- **Prefer tool-native commands over shell built-ins.** `git`, the package manager
  (`npm`/`pnpm`/`pip`/`cargo`…), and the project's own CLI behave identically on every
  OS. Reach for `npm run <script>` or `git ...` before `cp`, `rm`, `grep`, `chmod`,
  `find`, `sed`, or `&&`-chained shell one-liners.
- **Don't assume a POSIX shell or GNU tools.** No `rm -rf`, `cp -r`, `grep -r`,
  `chmod`, backtick subshells, `$VAR` expansion, or `/absolute/unix/paths` in
  general-audience docs. These fail or differ on Windows `cmd`/PowerShell and even
  between BSD and GNU `grep`/`sed`.
- **Use forward slashes and relative paths.** Git and most cross-platform tools accept
  `path/to/file` on every OS; avoid `\` and machine-specific absolute paths.
- **When a shell command is unavoidable, do one of:** (a) use cross-platform tooling
  (e.g. ripgrep `rg`, or a language one-liner), (b) provide per-OS variants under clear
  labels — `macOS / Linux:` and `Windows (PowerShell):`, or (c) state the OS the snippet
  targets.
- **Label any OS-specific section explicitly** so a reader on another OS knows to adapt.

**Documented exception:** the shipped automation in `ai/scripts/*.sh` is written for a
POSIX shell (native on macOS/Linux; available on Windows via Git Bash or WSL). That is
noted in `ai/agent-setup.md`; everything else should be OS-agnostic.

## Screenshots (if your docs use them)

- Generate them with your E2E tool against a stable demo/seed dataset
  (`{{E2E_COMMAND}}`) rather than capturing by hand — hand-captured shots rot.
- Mask volatile or sensitive data (names, emails, dates, ids). Capture light **and**
  dark themes if the product has both.
- Commit generated screenshots as artifacts in a clearly-marked generated directory;
  never hand-edit generated output.

## Adding documentation for a NEW surface (workflow)

Adapt to your stack; the order matters more than the exact steps:

1. Register the new surface where surfaces are listed (route table, command
   registry, etc.).
2. Add its entry to the source-of-truth help content (overview, common tasks, and
   per-field text). If you have a doc gate, it fails until this exists.
3. Wire inline help into the surface at every field that passes the tooltip test
   above (jargon, non-obvious option, format, or side effect).
4. Add the long-form manual page (it transcludes the generated short-help partials),
   add prose and a screenshot, and link it from navigation.
5. Regenerate any derived artifacts (partials, screenshots).

## Keep-current rule (mandatory)

Every PR that ships user-visible UI/behavior MUST, in the same PR:

- add/update the surface's help content (overview/tasks/field help) — including
  inline help on any field a non-expert could trip over,
- update the matching long-form manual page, and
- regenerate any derived artifacts (partials, screenshots) for changed surfaces.

Purely internal changes (refactors, tests, infra with no UI impact) are exempt.
A preflight/CI check should **warn** when a user-visible change carries no docs
change; the doc-gate test (if present) is the **blocking** gate.
