# T19 — Session-start protocol consolidation

**Category:** Gap (created by accumulated decisions) · **Status:** **Decided (2026-07-09)** · **Related:** T8.5/T8.6, T13.8, T3.9, release trigger

**Gap:** four session-start checks now exist, defined in four places — release trigger (versioning standard), board check (T13.8), evergreen cadence (T8.5), scaffold-trigger detection (T3.9). No single ritual = the "fell off due to expediency" failure shape.

**Decision:** one **session-start protocol**, defined in exactly one place (agent-setup.md, referenced from CLAUDE.md per T11's rules-vs-rationale split): the ordered check list, each check **non-interruptive** per the T8.6-0 rule — output is one status line or a filed issue, never a derailment of the task the human arrived with. New checks may only be added to this list, not scattered.
