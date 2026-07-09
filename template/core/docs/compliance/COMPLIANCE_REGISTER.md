# Compliance Register — {{PROJECT_NAME}}

The obligations that actually bind **this** project, derived from
`ai/STANDARDS/EXTERNAL_STANDARDS_AND_COMPLIANCE.md`. The standard is the generic
catalog; this file is the project-specific source of truth for what applies, who
owns it, and whether it's met.

- **Update this** whenever platforms, audience, regulated data, or features change.
- Each row records a **Verified** date — when the live official source was last checked
  (store policies and child-safety law change frequently; an old date is a risk).
- `/compliance` reads this file to decide which obligations a change triggers.

## Project profile

| Field | Value |
|---|---|
| Target platforms | `{{TARGET_PLATFORMS}}` |
| Audience (incl. age) | `{{AUDIENCE}}` |
| Regulated data handled | `{{REGULATED_DATA}}` |
| Obligation-bearing features | `{{COMPLIANCE_FEATURES}}` |

## Baseline obligations (universal)

Every project carries these — they are not trigger-driven and are pre-seeded at
inception. Statuses still get owned, met, and re-verified like any other row.

| ID | Obligation | Owner | Status | Verified | Evidence |
|----|-----------|-------|--------|----------|----------|
| B-001 | **Secrets handling** — no credentials in the repo, ever; `.env` is local-dev only and gitignored; deployed environments use the platform secret store | | ☐ | YYYY-MM-DD | |
| B-002 | **Dependency hygiene** — SCA/vulnerability scanning runs (`{{SECURITY_SCAN_COMMAND}}`), and dependency updates have a named owner and cadence | | ☐ | YYYY-MM-DD | |
| B-003 | **License correctness** — the LICENSE file matches the recorded license decision, and dependency licenses are compatible with it | | ☐ | YYYY-MM-DD | |
| B-004 | **Data-subject basics** *(applies as soon as any user data exists)* — what's collected is written down, users can get their data deleted on request, and a retention stance is recorded | | ☐ | YYYY-MM-DD | |

## Active obligations (conditional — trigger-driven)

| ID | Trigger | Obligation | Applies because | Owner | Status | Verified | Evidence |
|----|---------|-----------|-----------------|-------|--------|----------|----------|
| C-001 | _e.g. web UI_ | WCAG 2.2 AA | _project ships a web UI_ | | ☐ Not started / ◐ In progress / ✅ Met / ➖ N/A | YYYY-MM-DD | _link_ |

<!--
WORKED EXAMPLE — delete or adapt. Profile: mobile app, audience 14+, includes staff↔user messaging.

| ID | Trigger | Obligation | Applies because | Owner | Status | Verified | Evidence |
|----|---------|-----------|-----------------|-------|--------|----------|----------|
| C-001 | mobile release | Apple privacy labels + Play Data safety form match actual collection | iOS + Android release | | ◐ | 2026-06-24 | |
| C-002 | mobile release | In-app account & data deletion | app has accounts | | ☐ | 2026-06-24 | |
| C-003 | mobile release | Meet current Play target API level | Android release | | ☐ | 2026-06-24 | |
| C-004 | mobile release | Honest age rating reflecting messaging/UGC | rated 14+ with messaging | | ☐ | 2026-06-24 | |
| C-005 | messaging/UGC | Report + block + moderation + response-time SLA | staff↔user messaging | | ☐ | 2026-06-24 | |
| C-006 | minors | UK Children's Code: DPIA + high-privacy defaults | service likely accessed by under-18s | | ☐ | 2026-06-24 | |
| C-007 | minors | EU Art.8 consent-age path (parental consent where 14–15 is under threshold) | EU teen users | | ☐ | 2026-06-24 | |
| C-008 | minors + messaging | Safeguarding stance for adult(staff)-to-minor contact | staff message minors | | ☐ | 2026-06-24 | |
| C-009 | personal data | Privacy notice + data-subject rights (access/delete/export) + retention | collects personal data | | ☐ | 2026-06-24 | |
-->

## Decisions & scoping notes

Record here anything deliberately scoped **out**, with the reasoning (e.g. "No EU
launch at MVP → DSA duties deferred; revisit before EU release"). Out-of-scope is a
valid status, but it must be a recorded decision, not an omission.
