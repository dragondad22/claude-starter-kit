# T29 — Project-concept intake: shared understanding before the targeted interview

**Category:** Process (inception flow) · **Status:** Not discussed · **Issue:** #92 (filed at intake; implementation blocked on this topic) · **Related:** T15 (inception machinery), T27.1 (harvest = pre-answered interview from evidence — the same move at rebuild scale), T20 (arrived via the retrospective channel), T26 (the brief is human-facing text)

**Origin (life-os trial, 2026-07-10/11):** first from-scratch inception. The repo was empty, yet the interview arrived already framed — the AI's concept of the project came from the repo name plus chat, with no place where the human states plainly what the app is, the problem it fixes, or its goals, and nothing reviewed or approved as the shared understanding. Risk observed: getting pigeonholed into a concept that isn't quite what the user wants.

**Proposed flow (Chris, 2026-07-11):** before generating the interview from the question bank: (1) ingest existing context if present — concept doc, spec sheet, PRD, existing repo files; (2) produce a freetext **project brief** — where context exists the AI writes its understanding (what the app is, scope, goals, problem areas) for the human to edit/approve; where none exists the human fills it in, guided by thinking prompts; (3) only then generate the targeted interview, seeded by the approved brief.

**To decide:** the brief's home and lifecycle (candidate: alongside `000-inception/`; is it a founding artifact with provenance links?); the approval-gate mechanics; how the brief seeds and prunes the spine; whether this is `/bootstrap` step 1 or a step before it; relationship to T27.1's harvest (one mechanism, two scales?).

**Decision:** —
