# Personas — Claude Starter Kit

The central persona registry: every persona this project designs for, defined
once. Specs, UAT docs, and issues reference personas from here **by name — never
redefine one inline**. Glossary role-term entries cross-link here; the
role/permission mapping is the bridge to RBAC when the project has one.

Seeded at inception from the audience answers; extended when a feature
interview surfaces a new kind of user. Update a persona here (one place) when
reality changes — not in the documents that cite it.

Each persona records:

- **Who they are** — one or two plain sentences.
- **Goals** — what they are trying to get done with the product.
- **Role / permission mapping** — the system role(s) they hold, if the project
  has roles or RBAC ("n/a" is fine).
- **Context & constraints** — environment, device, technical comfort, and
  anything that shapes how they use the product (time pressure, accessibility
  needs, offline field work, …).

---

The kit has no user interface and produces no feature specs, so this registry
stays deliberately short. Two readers actually shape decisions here; inventing
more would be depth this project cannot use.

## Adopting developer

**Who:** A developer bringing the kit into a project of their own — sometimes a
greenfield repo, more often an existing one with its own habits, layout and
half-followed conventions. Competent, busy, and evaluating whether the kit earns
its place.
**Goals:**
- Get a working process installed without reading the whole kit first
- Understand *why* a rule exists when it costs them something
- Adapt what does not fit their stack, without silently forking the kit
**Role / permissions:** n/a — no runtime roles; they own their own repo.
**Context & constraints:** Reads standards as **distributed copies**, in their
repo, usually with no practical access to this project's history — so a stale
`Last Updated` or a rule with no stated rationale is unfalsifiable from where
they sit. Adopts mid-project far more often than at inception, which is why
retrofit and conform paths matter as much as scaffolding.

## Kit maintainer

**Who:** Whoever is changing the kit itself — deciding topics, editing shipped
standards, cutting releases. Currently one person plus an AI pair.
**Goals:**
- Change shipped content without breaking adopters downstream
- Keep decisions findable years later, and not re-litigate them
- Notice when the kit's own docs stop describing what it ships
**Role / permissions:** n/a.
**Context & constraints:** Works in a repo that is **both the product and an
adopter of it**, so every change has two audiences and the two trees must not be
confused. Long gaps between sessions make conversation memory worthless — the
record is the only reliable state.
