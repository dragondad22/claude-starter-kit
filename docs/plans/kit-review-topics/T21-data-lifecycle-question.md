# T21 — Data-lifecycle question in the inception spine

**Category:** Gap · **Status:** **Decided (2026-07-09)** · **Related:** T15 spine, T10.4 (environments), runbooks module

**Gap:** T10.4 decides where data lives, nothing decides what happens when it's lost.

**Decision:** the data section of the spine gains a question: backup cadence, restore story, acceptable-loss window — with a right-sized recommendation ("weekend CLI → none, and that's fine" is a legitimate recorded `Final:`). Backup/restore runbook scaffolded only when the answer warrants it.
