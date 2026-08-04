# Glossary — Claude Starter Kit

**Audience:** a competent developer who is new to this project, its domain, and
its toolchain.

The shared AI↔human vocabulary, bidirectional by design: **Domain terms** teach
this project's language (human → AI, and to every future reader); **Technical
terms** explain the platform/standards concepts the repo depends on, in plain
English (AI → human). Explanations given in chat evaporate — this file is where
they survive.

**Recording rules** — capture inline at the moment of resolution, never as an
end-of-session batch. Record a term when any of these fires:

1. **Explained-in-chat** — a human asked, or the AI had to explain → record
   before the session ends.
2. **Coined** — a new domain noun/verb enters schema, code, or issues (an
   entity, status value, role name) → record at introduction time; confusion
   is not required (the glossary serves future readers, not just the current
   pair).
3. **Overloaded common word** — an everyday word with a repo-specific meaning →
   record the canonical qualified form, with `_Avoid_:` aliases.
4. **Load-bearing external concept** — an acronym, platform feature, or
   legal/standards concept the repo depends on → record on first doc/issue use.

Don't record general programming vocabulary at its ordinary meaning — unless
rule 1 fired.

**Authority:** this glossary is the naming reference for code, docs, and
issues. The AI challenges glossary-conflicting usage on sight; overloaded terms
get sharpened to one canonical choice instead of drifting as synonyms.

Entry format: `**Term** — plain-English definition; why it matters here when
non-obvious. _Avoid_: aliases.`

## Domain terms

<!-- Seeded by /bootstrap from the inception interview (domain answers,
non-negotiables vocabulary); grows via the recording rules. Role terms
(apprentice, admin, …) cross-link to their entry in docs/PERSONAS.md. -->

This project's domain **is** the starter kit itself, so the terms below are the
vocabulary of building and adopting one. Several are ordinary English words with
a narrow meaning here — those carry `_Avoid_:` lines, because the ambiguity is
the whole problem.

### The two trees

- **The kit** — this product: a stack-agnostic set of standards, checklists,
  commands and scaffolding that a project installs and then works by.
- **Product tree** — `template/`, the only tree scaffolding ever reads and the
  only content that ships. _Avoid_: calling it "the templates" — it holds
  standards and commands, not just fill-in-the-blank files.
- **Kit development (kit-dev)** — everything outside `template/`: this repo's own
  CI, scripts, decision records and fixtures. Never ships, and safe by default
  because the manifest is an allowlist.
- **Manifest allowlist** — `template/manifest.yml`, mapping module → files →
  scaffold trigger. Only listed files ship, so a new kit-dev file needs no action
  and an unlisted shipped file silently doesn't exist to adopters.

### This repo as its own adopter (T36)

- **Instance** — the copy of the kit's core installed at this repo's root
  (`ai/`, `.claude/`, `docs/`). It is what governs work *here*; `template/` is
  what we *build*. _Avoid_: "the root files" — the distinction that matters is
  derived-vs-product, not location.
- **Derived** — content generated from `template/` by filling this project's
  answers and stripping the banner. A derived file is **never authored
  directly**: change `template/`, then re-derive.
- **Adaptation** — a declared, reasoned divergence of one instance file from the
  template, listed in `ADAPTATIONS.md`. The only legal way for the instance to
  differ, and therefore the only place divergence is visible.
- **Seeded** — a shipped file that is a *starting skeleton* the project fills
  (rolling logs, registries, decision records). Divergence is the file doing its
  job, so only its existence is checked. Distinct from an adaptation: a seeded
  file was never meant to stay equal.
- **Pin** — the release the instance tracks (`bootstrap/KIT_VERSION`),
  deliberately the last *release* rather than the working tree. The resulting lag
  is what makes each release a real self-upgrade.
- **Self-upgrade** — adopting a newly cut release into the instance. The step
  that exercises declared adaptations colliding with upstream change.

### Adopting the kit — four verbs that are not synonyms

- **Scaffold** — install the kit's core into a target repo. Additive; never
  overwrites an existing file.
- **Retrofit** — scaffold into a repo that already exists, adding only the kit
  pieces it lacks. Additive only.
- **Conform** — tidy an already-adopted repo to current kit standards: naming,
  layout, tracker. No behaviour change.
- **Rebaseline** — the heavy tier: harvest what a messy or false-start repo knows,
  then rebuild against an agreed plan. _Avoid_: using these four
  interchangeably; they are ordered by how much they disturb, and picking the
  wrong one is the difference between a tidy-up and a rebuild.

### Working vocabulary

- **T-topic / T-ID** — one decision in this repo's decision record, with a stable
  id (`T36`) and sub-items (`T36.4`). Superseded entries are stamped in place,
  never rewritten, so a T-ID is a permanent address.
- **Grill** — a structured interrogation of an open topic before deciding it:
  options with trade-offs, a recommendation, and an explicit record of what was
  *not* asked and why. Produces a `Decision:` block, not a conversation.
- **Port-back** — an improvement discovered while using the kit in a real project,
  filed against the kit so every adopter gets it. The main channel by which the
  kit learns from practice.
- **Paved road** — the house default for a tool or data format
  (`bootstrap/PAVED_ROAD.md`), with a last-reviewed date. Deviating is allowed and
  requires a recorded decision — it is a default, not a mandate.
- **Placeholder / token** — `{{LIKE_THIS}}`, filled per project at adoption.
  **Meta-literals** (`{{TOKENS}}`, `{{TOKEN}}`, `{{PLACEHOLDER}}`) are
  illustrative text *about* the system and are never filled.
- **Genericization banner** — the line-1 note marking a shipped file as not yet
  adapted to this project. Ships in **two forms**: an italic line on standards and
  commands, an HTML comment on templates and seeded docs (invisible when
  rendered) — tooling that handles only one form leaves the other behind.
  Adopting a file unchanged still counts as adapting, so whichever path adapts it
  strips the banner.
- **Blast radius** — what a change can *reach*, as opposed to how many lines it
  touched. A one-line vocabulary edit can break every form consuming it, which is
  why "large" is defined by reach.
- **Verdict / advisory** — the two authority classes for a reviewing agent. A
  *verdict* is objectively falsifiable with cited evidence and may gate; an
  *advisory* finding cites a written clause but never blocks. Invariance is a
  property of the agent, not a blanket rule.

## Technical terms

- **ADR (Architecture Decision Record)** — a short doc recording one
  architectural decision: context, the decision, consequences, alternatives.
  Numbered `ADR-NNN`; superseded, never rewritten. Path: `CLAUDE.md` § Decision
  Recording (kit default `docs/architecture/decisions/`).
- **Register** — a document holding **standing truth**: what is currently true,
  by ID, kept current. The kit ships several — the product register
  (`docs/registers/`, business rules, stories, acceptance criteria, NFRs,
  invariants, UX clauses), the compliance register, the journey registry, the
  glossary and persona registry. Contrast a **proposal** (a feature spec), which
  says what was *proposed* and carries no authority until consumed.
  _Avoid_: "decision log" — a decision is an event, not a content type; what it
  produces lands in an ADR or a register row (`CLAUDE.md` § Decision Recording).

- **Epic / sub-issue** — an epic is a parent issue grouping a workstream
  (`type:epic`); its breakdown lives in native sub-issues. Milestones mean
  releases only, never epics.
- **Projects v2** — GitHub's current project boards (the table/board views with
  custom fields like Status). This repo keeps exactly one, with Status =
  Backlog / Next / In progress / Done.
- **UAT (User Acceptance Testing)** — verifying a feature against what the
  user/stakeholder actually needs, not just what the code does; acceptance
  criteria live in `docs/uat/` when the reports module is installed.
- **Beta guide** — the human-facing UAT artifact: a task-based hand-off for
  beta testers — goals, not steps (scenario, starting point, done-condition;
  never a click-path). One per feature, `BETA-<DOMAIN>-NNN-<slug>.md` in
  `docs/uat/beta/` when the reports module is installed.
- **SCA (Software Composition Analysis)** — scanning dependencies for known
  vulnerabilities (e.g. `npm audit`, `pip-audit`). One of the standing quality
  gates.
- **DPIA (Data Protection Impact Assessment)** — a documented privacy risk
  assessment required by GDPR/UK rules for high-risk processing — fires for
  this project only via the compliance trigger map (e.g. services minors use).
- **SemVer (Semantic Versioning)** — `MAJOR.MINOR.PATCH`; only Fixed/Security →
  patch, any Added/Changed → minor, breaking → major (post-1.0). Versions move
  in lockstep at release time only.
- **Conventional Commits** — commit/PR-title format `type(scope): summary`
  (`feat:`, `fix:`, `chore:`…); the squash-merged PR title becomes the commit.
- **Keep a Changelog / `[Unreleased]`** — the CHANGELOG format: entries
  accumulate under `[Unreleased]` per PR and roll into a version heading at
  release time.
- **E2E (end-to-end) test** — a test driving the real application surface (UI
  or API) through a full user flow, as opposed to unit/integration tests.
- **ERD (Entity-Relationship Diagram)** — the canonical picture of the data
  model; updated in the same PR as any schema change.
- **Runbook** — a step-by-step operational how-to (restore a backup, rotate a
  secret, find errors in logs). Lives in `docs/runbooks/` (kit default).
- **Module (kit sense)** — optional starter-kit content staged dormant under
  `bootstrap/modules/` and installed when its trigger fires (first schema file,
  first UI code, …). _Avoid_: confusing with language/package modules.
- **KIT_VERSION** — `bootstrap/KIT_VERSION`, the marker recording which
  starter-kit version scaffolded this project and which modules are installed.
- **Q-ID** — an inception/epic interview question id; short in its own file
  (`Q-ARCH-03`), always qualified in cross-references (`000/Q-ARCH-03`). See
  `ai/STANDARDS/INTERVIEW_STANDARD.md`.
- **Non-negotiables** — this project's never-re-litigate architectural
  constraints, listed in `CLAUDE.md`; changing one requires a recorded decision,
  not a conversation.
- **Feature spec** — a journey-first two-layer feature document in
  `docs/specs/` (`SPEC-<DOMAIN>-NNN`): plain-language journey on top for
  non-technical stakeholders, technical spec below for AI/devs/UAT. Self-contained:
  it states what must be true and *refers to* ADRs and decisions, never prescribing
  them.
  _Avoid_: calling a spec a "workflow doc" — specs are journey-first and
  two-layer, not process descriptions. (Repos with a legitimate `workflow`
  doc surface of their own are unaffected — the rule is about what specs are
  called, not a ban on the word.)
