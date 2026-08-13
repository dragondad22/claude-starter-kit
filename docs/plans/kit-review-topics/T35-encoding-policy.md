# T35 — Encoding policy: markdown-first vs fit-for-purpose formats

> **DRAFT — opened 2026-07-28 from the T33 grill. Kit-wide policy question; needs its own
> grilling session. Nothing decided. Cross-linked to [T32](T32-kit-runtime-evolution.md)
> (runtime/delivery) — siblings, not the same: T32 is execution, T35 is data encoding.**

**Category:** Structural (kit-wide convention) · **Status:** **Partially folded into [T32](T32-kit-runtime-evolution.md) 2026-08-13 (T32.11)** — the machine-consumed half is decided; the remaining scope is prose-facing and still needs its grill (**#162**, rescoped) · **Issue:** #162 (rescoped 2026-08-13 to the prose half) · **Related:**

> **Fold (2026-08-13, T32.11).** T32's grill decided the seam this topic was opened to find,
> because the event log's encoding *is* an encoding decision and T32 could not be settled
> without it. Two rulings now bind and are **not** re-litigated here:
> - **T32.5 — customisation is markdown plus configuration, never code.** The customisation
>   surface is prose a project edits; values live in a settings file.
> - **Machine-consumed records** — the event log, config, manifest, and markers — take the
>   format that fits, decided in T32 alongside the substrate that produces them.
>
> This is the candidate cut T35 itself proposed ("the same seam T32 found, applied to
> encoding"), confirmed rather than overridden. **What is left for #162** is the prose half:
> which *human-facing* markdown artifacts (registries, logs, tables carrying the ×3
> pipe-escaping note) have not earned their keep, and how readability is preserved for the
> humans who do occasionally look. That is a real question and it is unchanged. T32 (runtime/delivery — same judgment/enforcement seam, applied to encoding), T22 (context economy), T11 (duplication — the pipe-escaping-×3 note is markdown-table friction), T33 (first consumer — applied the principle in miniature)

**Problem / Origin:** Markdown became the kit's default because it is human-readable **and**
human-editable — letting users understand how things work and customize prompts/standards
to their taste. Chris (2026-07-28): *"I don't want to lock into everything has to be
markdown if something will serve us better, especially in things that humans will rarely
see. And it's not like other formats aren't readable."* With real experience now, the
question is where markdown has earned its keep and where a structured format serves better.

**Analysis captured at opening (grill input, not conclusion):**
- Markdown's two reasons — readable, editable — are real *where humans read and edit*
  (standards, playbooks, prompts, agent defs, personas). There it's also LLM-native and
  needs no schema. Correct default, untouched.
- Both reasons evaluate to *zero* for an artifact a human rarely opens and never hand-edits.
  There, markdown is overhead: fragile to parse, and tabular data is painful.
- The kit **already isn't pure-markdown** and the seam is latent: `manifest.yml` (YAML),
  `version-files.txt` (plain list); and two pain signals point the same way —
  `scaffold-module.sh` hand-rolls an **awk YAML parser** (structured data forced through a
  markdown-era toolchain), and T11 records the **pipe-escaping note duplicated ×3**
  (markdown-table friction already felt).
- Candidate cut: the **same seam T32 found**, applied to encoding — judgment/prose →
  markdown (human reads/edits/customizes); machine-consumed records humans rarely touch →
  the format that fits (YAML/JSON/JSONL/CSV). "Readable" isn't lost; *edit-ergonomics-for-
  humans* is what markdown optimizes, and that only matters where humans edit.

**Precedent set by T33 (applies the principle in miniature, to pressure-test it):**
markdown for human-curated/prose (standard, agent defs, briefs, and the journey registry —
with "revisit registry encoding if scale/pipe-escaping bites" flagged); JSONL for
machine-written/read run-records + de-dup keys (forward-compatible with T31's run-journal);
native artifacts for evidence.

**Open questions for the grill (seed):**
- Where exactly does the human-edits / machine-consumes seam fall across the kit's artifacts?
- Which existing markdown artifacts (registry, markers, logs) would be better structured?
- Does adopting structured formats where they fit conflict with T22 (context economy) or the
  customization goal — and how is readability preserved for the humans who *do* occasionally
  look?
- Relationship to T32: is encoding policy a sub-decision of the runtime evolution, or its own
  standing convention?

**Decision:** — (pending its own grilling session)

**Discussion notes:**
- Chris, 2026-07-28: raised at the T33 registry-format question as a "good guidepost
  moment"; wants a retro on how well markdown-first has worked rather than a snap answer
  inside a feature topic. Split out so the kit-wide call gets kit-wide scrutiny.
