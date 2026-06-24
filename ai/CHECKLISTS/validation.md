# Validation Checklist

Use this for security and performance validation after changes — especially for
auth, permissions, session, or data-access changes.

## Security Validation

### Automated Scans
- [ ] Security review run: `ai/scripts/security-review.sh <id> <slug>` (if configured)
- [ ] Dependency/SCA scan: `{{SECURITY_SCAN_COMMAND}}` — no high/critical runtime vulnerabilities
- [ ] CI security gates enabled (see `{{CI_SYSTEM}}`)

### AuthZ & Sessions
- [ ] Authorization enforced on all protected entry points
- [ ] Session/token handling correct (hashed at rest, expiry + idle timeout enforced, logout revokes)
- [ ] Privileged operations inaccessible to lower roles

### Tenant Isolation (if multi-tenant)
- [ ] Cross-tenant data access denied
- [ ] Tenant-scoped operations don't affect other tenants
- [ ] Multi-tenant users can switch context without data leakage

### Data Integrity
- [ ] No destructive deletes for critical records
- [ ] Audit entries created for sensitive operations
- [ ] Secrets never logged

## Performance Validation

### Smoke Benchmark
- [ ] Performance smoke run: `ai/scripts/performance-smoke.sh <id> <slug>` (if configured)
- [ ] Key signal within threshold: `{{PERF_TARGET}}`

### Regression Check
- [ ] No new N+1 / repeated-query patterns
- [ ] No unbounded queries or responses (pagination/limits present)

## Reporting
- [ ] Findings documented with severity and evidence
- [ ] Report saved under `testing-reports/` if formal validation
- [ ] Tracked issues created for threshold-breaching findings per `ai/STANDARDS/GITHUB_ISSUES.md`
