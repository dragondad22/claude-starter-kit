# T11 — Duplication with sync burden (multi-tenant doctrine ×8, pipe-escaping note ×3)

**Category:** Efficiency · **Status:** **Decided (2026-07-08)** — "rules may repeat; rationale may not"

- **T11.1** — The multi-tenant isolation doctrine is stated in ~8 files (DB/security/testing/logging/UAT standards + coding/qa/validation checklists). Checklist repetition is *correct* (gates must be self-contained), but the explanatory versions could live once (security standard) with references elsewhere. As-is, changing the doctrine means an 8-file sweep — the exact drift risk the kit's own Impact Analysis gate warns about.
- **T11.2** — The "markdown table pipe escaping" note appears 3× (testing standard, security standard, security template). Tooling trivia — one mention, not three.

**Question to settle:**
- **T11.3** — where's the line between deliberate redundancy (self-contained gates) and drift-prone duplication? Decide the rule, then apply.

**Discussion notes:**
- 2026-07-08 (Chris): agrees with the proposed rule.

**Decision (2026-07-08):** **"Rules may repeat; rationale may not."** Checklists may restate rules as terse imperative one-liners (gates must be self-contained at point of use), but the explanation — why, threat model, patterns, examples — lives in exactly one standard; every other appearance is one line + a pointer. Doctrine changes = update one explanation + sweep the grep-able one-liners. Tenant-isolation explanation consolidates into the security standard. The pipe-escaping note survives as a single line in the diagnostic-bundle format definition (T5.7 collapsed the other copies).
