# OPERATIONS Guide

Version: v2.1

Overview
- This guide outlines day-to-day operations, on-call procedures, incident response, change management, deployments, SLOs/SLIs, monitoring, and runbooks.
- Audience: engineers, SRE, and operations staff.

Environments
- Prod: primary customer-facing.
- Staging: pre-prod validation, mirrors prod.
- Dev: feature testing.
- Data regions: note any regional constraints and residency requirements.

Ownership & Contacts
- On-call (primary/secondary): see PagerDuty schedule: ops-core.
- Escalation ladder: L1 On-call -> L2 Platform -> Eng Manager -> Director.
- Comms channels: #ops-alerts, #incidents, email: ops@company.tld.

Service Level Objectives
- Availability (prod): 99.9% monthly.
- Latency (p50/p95): API read < 150ms/500ms; write < 300ms/800ms.
- Error rate: < 1% 5xx per service.
- Data freshness (ETL): < 15 min lag p95.
- Page load (web): LCP < 2.5s p75.

Monitoring & Alerting
- Metrics: Prometheus/Grafana dashboards: "Platform Overview", "API", "DB", "Queues".
- Logs: Loki/ELK; retention 30 days.
- Tracing: OpenTelemetry/Jaeger.
- Alerts: actionable, severity S1–S4 with runbook links. Use auto-silence during maintenance.

Incident Response
- Severity matrix:
  - S1 Critical: full outage/security breach; customer impact high; RTO < 30m. All-hands bridge.
  - S2 Major: partial outage/degradation; RTO < 2h.
  - S3 Minor: limited impact; business hours response.
  - S4 Informational: no impact; track and triage.
- First responder checklist:
  1) Acknowledge page within 5 minutes.
  2) Open incident channel and status page entry (S2+).
  3) Assign roles: IC, Ops, Comms, Scribe.
  4) Stabilize: rollback/scale/switch traffic; capture timelines.
  5) Comms cadence: every 30m (S1/S2) or on major changes.
  6) Declare resolved; schedule postmortem.
- Status page: template includes summary, impact, timeline, mitigation, next steps.

Postmortems
- Blameless, completed within 5 business days for S1/S2.
- Include: impact, detection, root cause, contributing factors, what went well, what didnt, action items with owners/dates.
- Track action items to closure; review in ops weekly.

Change Management
- Proposals via RFC in /docs/rfcs; risk assessed (Low/Med/High).
- Maintenance windows: Tue/Thu 02:00-04:00 UTC for High risk.
- Approvals: Low (self), Med (peer + on-call), High (EM + on-call).
- Pre-deploy checklist: tests green, health checks, backups/snapshots, comms drafted, rollback plan.

Deployments
- CI/CD: trunk-based; protected branches; required checks.
- Progressive delivery: canary 5% -> 25% -> 50% -> 100% with auto-rollback on SLO breach.
- Infra changes via IaC (Terraform); review and plan output attached to PR.
- DB migrations: backward-compatible; gated by feature flags.

Runbooks (linked)
- API elevated errors: check dashboard -> error budget -> recent deploys -> feature flags -> roll back if correlated.
- Database CPU high: inspect slow queries, indexes, connection pool, failover if primary unhealthy.
- Queue backlog: scale workers, inspect poison messages, DLQ drain procedure.
- Cache miss storm: warm cache job, TTL review, rate-limit hot keys.
- TLS/Cert expiry: monitor 30/7/3-day alerts; renew via ACME; reload.

Security Operations
- Patching: monthly baseline; critical CVEs within 72h.
- Secrets: managed in vault; rotate quarterly and on incident.
- Access: least privilege; JIT elevation with approvals; quarterly reviews.
- Audit: central logging; anomaly detection; incident playbooks for authz/authn abuse.

Backups & DR
- Backups: daily full + hourly incrementals; verify restores weekly.
- RPO/RTO: DB RPO 15m, RTO 1h; object store RPO 0, RTO 4h.
- DR tests: biannual failover exercises; document gaps.

Capacity & Performance
- Forecast quarterly using trend data; maintain 30% headroom in prod.
- Load tests before major releases; capture baselines.

Cost Management
- Budgets per service; alerts at 50/75/90% of monthly budget.
- Tagging enforced; weekly cost review and rightsizing.

Compliance
- Data handling: PII encrypted at rest/in transit; DSR within 30 days.
- Retention: logs 30d, metrics 13m, backups 35d (or per policy).
- Vendor reviews annually; SOC2 controls mapped.

Documentation
- Keep runbooks in /runbooks; link from alerts.
- Update this guide each release.

Appendix
- Glossary of terms: SLO, SLI, RTO, RPO, IC, DLQ, etc.
- Contacts roster link; tooling dashboards links.
