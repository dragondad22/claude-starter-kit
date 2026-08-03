# Compliance Register — Claude Starter Kit

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
| Target platforms | `macOS + Linux developer machines (stock bash 3.2)` |
| Audience (incl. age) | `developers using Claude Code, general adult` |
| Regulated data handled | `none` |
| Obligation-bearing features | `none (MIT open-source distribution)` |

## Baseline obligations (universal)

Every project carries these — they are not trigger-driven and are pre-seeded at
inception. Statuses still get owned, met, and re-verified like any other row.

| ID | Obligation | Owner | Status | Verified | Evidence |
|----|-----------|-------|--------|----------|----------|
| B-001 | **Secrets handling** — no credentials in the repo, ever; `.env` is local-dev only and gitignored; deployed environments use the platform secret store | Chris | ✅ Met | 2026-08-03 | No runtime and no deployed environment: the kit stores nothing and calls nothing. `.gitignore` excludes `.env`; CI uses no secrets beyond the default `GITHUB_TOKEN`. |
| B-002 | **Dependency hygiene** — SCA/vulnerability scanning runs (`N/A (no third-party dependencies)`), and dependency updates have a named owner and cadence | Chris | ➖ N/A | 2026-08-03 | Nothing to scan: shipped content is markdown + POSIX shell; kit-dev tooling is stdlib Python plus PyYAML installed in CI only. Revisit if the kit ever gains a runtime dependency (T32 could change this). |
| B-003 | **License correctness** — the LICENSE file matches the recorded license decision, and dependency licenses are compatible with it | Chris | ✅ Met | 2026-08-03 | MIT, matching the recorded decision (T23 § open source). No dependencies to conflict with. The kit's own README/LICENSE are kit artifacts, not templates. |
| B-004 | **Data-subject basics** *(applies as soon as any user data exists)* — what's collected is written down, users can get their data deleted on request, and a retention stance is recorded | Chris | ➖ N/A | 2026-08-03 | The kit collects nothing. It is files copied into someone else's repo; it has no users in the data-protection sense and no telemetry. Would fire immediately if the kit ever reported usage anywhere. |

## Active obligations (conditional — trigger-driven)

| ID | Trigger | Obligation | Applies because | Owner | Status | Verified | Evidence |
|----|---------|-----------|-----------------|-------|--------|----------|----------|
| — | — | _No conditional obligation currently fires._ | Profile is: no web UI, no mobile release, no public API, no messaging/UGC, no payments, no personal data, no minors. | Chris | ➖ N/A | 2026-08-03 | Re-checked against `EXTERNAL_STANDARDS_AND_COMPLIANCE.md` trigger map on 2026-08-03. |

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

**Scoped out, deliberately:**

- **Accessibility (WCAG)** — no user interface ships. The kit *writes about*
  accessibility (`UI_STANDARD`, and the driver-contract claim that a drivable app is
  an accessible one) but presents no surface of its own. Fires the moment the kit
  gains any rendered UI.
- **Distribution obligations** — GitHub releases of source under MIT carry no app-store
  or platform duties. Fires if the kit is ever packaged and distributed as a binary,
  which **T32 is actively considering** — flagged there rather than assumed away.
- **Telemetry / usage data** — none collected, by choice rather than by omission.
  Any future "how is the kit being used?" measurement makes B-004 live immediately.

*Empty is a finding, not a default:* this register was seeded on 2026-08-03 and its
rows are answered, not left blank. An unanswered register is indistinguishable from
an unconsidered one.

