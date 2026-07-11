# T2 — macOS portability of `ai/scripts/*.sh` vs. the "native on macOS/Linux" claim

**Category:** Bug / OS-agnostic principle · **Status:** **Decided (2026-07-08)** — option (a), portable scripts; kit to be open-sourced

`release.sh`, `new-report.sh`, and `lib/redact.sh` use GNU-only `sed -i` (no suffix arg; release.sh also uses the GNU-only `0,/addr/` form). `release.sh` and `check-version-sync.sh` use `mapfile` (bash 4+; macOS ships bash 3.2). README and `agent-setup.md` claim the scripts run "native on macOS/Linux" — on stock macOS they fail. OS-agnosticism is a headline design principle of the kit.

**Options:**
- (a) Fix the scripts properly: portable `sed` usage (`sed -i.bak` + rm, or awk), replace `mapfile` with `while read` loops. Keeps the claim true.
- (b) Soften the claim: "Linux / Git Bash / WSL; macOS needs GNU coreutils + bash 4".
- (c) Rewrite scripts in a truly portable language later (bigger lift, probably not worth it).

**Recommendation from review:** (a) — the fixes are mechanical and the principle is worth keeping honest.

**Discussion notes:**
- 2026-07-08 (Chris): **the kit is intended to be open-sourced** — out-of-box compatibility with as many systems as possible is the goal (nice-to-have, not hard requirement). → Option (a).

**Decision (2026-07-08): option (a) — make the scripts genuinely portable.**
- Replace GNU-only `sed -i` usage with portable forms (`sed -i.bak` + cleanup, or awk); eliminate the GNU-only `0,/addr/` address form; replace `mapfile` with `while read` loops (bash 3.2-compatible for stock macOS).
- Scope note: the script inventory this applies to has shrunk via T5/T6/T8 retirements (`log-self-correction.sh` gone; `new-report.sh` retired/repurposed; report templates collapsed). Portability fixes apply to the survivors: `release.sh`, `check-version-sync.sh`, `lib/redact.sh`, and the two stubs.
- Add a lightweight portability check to the kit's own CI (the kit repo can run its scripts on a macOS runner — eat the dogfood).
- **Scope addition (2026-07-09, from second-pass review):** kit self-test CI — smoke-test `/bootstrap` against a fixture repo, validate scaffold modules, lint for dead cross-references (the rot class the 2026-07-08 review found by hand).
- The "native on macOS/Linux" claim stays, and becomes true.
- **Open-source context recorded:** also validates prior choices — paved-road registry as a swappable data file (T16.1), stack-agnostic machinery vs. owner data separation, MIT license on the kit repo (T4).
