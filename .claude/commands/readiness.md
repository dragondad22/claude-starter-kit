Assess a whole release rather than a change: run the gates against the assembled product and record the evidence.

Every other gate this project ships is **diff-scoped** — `/qa`, `/security`, `/perf` and `/preflight` all evaluate what just changed. A release can therefore be built entirely from individually-green changes and never once be assessed *as a release*. This command is the one level up. Rules: `ai/STANDARDS/RELEASE_STANDARD.md` § Readiness.

Run it while a release is being prepared, not on the day of the cut — its findings are usually work, and work found on cut day delays the cut.

## Procedure

1. **Identify the release.** Read `docs/releases/README.md` for the promise, the audience, and the archetype. No named release recorded → stop and ask for one: everything below is scoped to a promise, and there is nothing to assess without it.

2. **Report the manifest, do not restate it.** From the release's milestone: committed items still open, items removed after being committed (each needs a recorded reason), and anything carrying `triggered` whose event has since fired — a fired trigger is a dormant commitment waking up, and nothing else will notice it.

3. **Assert against the register, capability by capability.** This is what makes the run checkable rather than a checklist — before `docs/registers/PRODUCT_REGISTER.md` there was nothing product-wide to assert against:
   - **`AC-` rows** for every committed capability — verify each and record the outcome **against the criterion's ID**, never by restating it.
   - **`INV-` rows** — these must hold under any input, role, or request shape, so check them against the assembled product rather than the diff that introduced them. An invariant that only ever held in the PR that added it is the failure this step exists to catch.
   - **`NFR-` rows** — each carries a number; measure it at the release's expected scale, not at development scale.
   - Where the review module is installed, journeys required by the promise and **already working** are the release's regression set (`docs/uat/JOURNEY_REGISTRY.md`) — run `/review` against them rather than re-deriving a list here.

4. **Run the existing gates release-scoped.** `/qa`, `/security` and `/perf` normally read the diff; here the scope is the assembled product and everything the release touched since the last one. Say so explicitly when invoking them, and record what each covered — a gate whose scope is unrecorded cannot be told apart from one that was skipped.

5. **Walk the gates that belong to no diff** — universal, then triggered, from `ai/STANDARDS/RELEASE_STANDARD.md`. For each: does it apply, what is the evidence, what date was it verified, who owns it. **Check the triggered conditions explicitly and record the ones that do not apply**, with the reason; an absent row and a considered "not applicable" look identical otherwise.

6. **File what has no evidence.** A gate that cannot be evidenced gets a tracked issue like any other missing work — *a gate that is nobody's issue is nobody's problem* — and that issue joins the milestone when the gate is universal or its trigger has fired. Aspirational goals are reported and **never** block.

7. **Write the record.** `docs/releases/RELEASE-<version>.md`, from `ai/TEMPLATES/RELEASE_READINESS_TEMPLATE.md`. Evidence with dates; anything not automatable is human-attested, dated, and named. Update the record on re-runs rather than starting a new one — the release has one record, and its history is the repository's.

8. **Report in one paragraph**: green gates, gates with no evidence and the issues now tracking them, and whether the milestone is empty. **Do not cut the release from here** — that is `/release`, and it is a separate decision a human makes.
