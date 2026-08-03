*Generic standard from the Claude starter kit — adapt to this project's stack. Replace `{{TOKENS}}`; see `bootstrap/PLACEHOLDERS.md`.*
*Optional — installed with the review module. The append-only record every `/review` run writes.*

# Review Run Journal

## Why a journal, and why JSONL

Every `/review` run appends **one JSON object per line** to a run journal. The journal is
the single substrate for three things that would otherwise be reinvented: **de-duplication**
(don't re-file a finding that already has an issue), the **batch summary** (what a run
filed / drafted / noted, read back at the end), and a durable **audit** of what was checked.

It is JSONL, not prose and not a markdown table, on purpose (the kit's fit-for-purpose
encoding rule): it is machine-written, machine-read, and a human rarely opens it directly —
they read the batch summary the run prints. Records are **objective facts and pointers**,
never narrative: a record says *what* was checked and *where the evidence is*, not a story.

## Location

- One journal per run, under the run's evidence directory in `testing-reports/`
  (local only, never committed — the same gitignored area as the diagnostic bundle).
- Suggested path: `testing-reports/artifacts/<date>_<run>/journal.jsonl`.

## Record schema

One object per line. Fields are flat and stable (so a later run, or a future dashboard,
can read them without parsing prose):

| Field | Meaning |
|---|---|
| `run` | run id — `<date>_<counter>` |
| `tier` | `blast-radius` \| `touched-by-diff` \| `critical` \| `full` \| `discover` |
| `journey` | `JRN-<DOMAIN>-NNN` |
| `persona` | persona name |
| `surface` | `web` \| `mobile` \| `api` \| … |
| `agent` | `review-uat-driver` \| `review-data-verifier` \| `review-ux-conformance` |
| `check` | invariant or criterion name (e.g. `offered-means-accepted`, `round-trip`, `EC-3`) |
| `class` | `verdict` \| `advisory` \| `note` |
| `result` | `pass` \| `fail` \| `blocked` |
| `evidence` | array of artifact paths — pointers, never inline content |
| `dedup_key` | stable string: `journey + check + surface` |
| `action` | `filed:#N` \| `drafted` \| `noted` \| `deduped:#N` \| `proposed` \| `blocked` |
| `reason_code` | for `blocked`/`deduped`: e.g. `no-storage-channel`, `driver-crash`, `prod-target`, `already-open` |

Add fields as the project needs them; never remove one — a consumer that reads the journal
should never break because a field vanished. (These flat objective facts are also the
forward-compatible shape a future unattended-execution run journal expects — log them
unconditionally even before anything consumes them.)

## How the run uses it

- **De-dup:** before filing a verdict, the run checks the journals of prior runs (and open
  issues) for the same `dedup_key`. A match → `action: "deduped:#N"`, and it references the
  existing issue instead of opening a new one.
- **Summary:** the end-of-run summary is a fold over this run's records — counts of
  filed / drafted / noted / blocked, grouped by journey — not a separately maintained tally.
- **Resume/audit:** the journal is the record of what actually ran, so a re-run or a review
  of a past run reads facts, not memory.

## Worked example

```jsonl
{"run":"2026-08-03_001","tier":"blast-radius","journey":"JRN-BATCH-002","persona":"Roastery apprentice","surface":"web","agent":"review-uat-driver","check":"offered-means-accepted","class":"verdict","result":"fail","evidence":["testing-reports/artifacts/<run>/batch-edit-save.png"],"dedup_key":"JRN-BATCH-002|offered-means-accepted|web","action":"filed:#412","reason_code":null}
{"run":"2026-08-03_001","tier":"blast-radius","journey":"JRN-BATCH-002","persona":"Roastery apprentice","surface":"web","agent":"review-data-verifier","check":"round-trip","class":"verdict","result":"fail","evidence":["testing-reports/artifacts/<run>/batch-status-query.txt"],"dedup_key":"JRN-BATCH-002|round-trip|web","action":"filed:#412","reason_code":null}
{"run":"2026-08-03_001","tier":"blast-radius","journey":"JRN-BATCH-005","persona":"Roastery apprentice","surface":"web","agent":"review-ux-conformance","check":"no-internal-ids-in-ui","class":"advisory","result":"fail","evidence":["testing-reports/artifacts/<run>/report-uuid.png"],"dedup_key":"JRN-BATCH-005|no-internal-ids-in-ui|web","action":"drafted","reason_code":null}
{"run":"2026-08-03_001","tier":"blast-radius","journey":"JRN-BATCH-005","persona":"Roastery apprentice","surface":"web","agent":"review-uat-driver","check":"done-condition","class":"verdict","result":"pass","evidence":["testing-reports/artifacts/<run>/report-ok.png"],"dedup_key":"JRN-BATCH-005|done-condition|web","action":"proposed","reason_code":null}
```

(The last line's `proposed` action marks a clean flow whose codified-spec proposal was
emitted for a coding step to land — see `ai/TEMPLATES/CODIFIED_SPEC_PROPOSAL_TEMPLATE.md`.)
