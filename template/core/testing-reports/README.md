Local home for failure diagnostics (the `/qa`, `/security`, `/perf` gates and
script stubs write here). Success needs no report — on failure, write a diagnostic
bundle per `ai/TEMPLATES/DIAGNOSTIC_BUNDLE_TEMPLATE.md`: enough evidence to fix
without re-running. Never committed: the artifacts/ subdir is gitignored, and CI
uploads bundles as run artifacts instead.
