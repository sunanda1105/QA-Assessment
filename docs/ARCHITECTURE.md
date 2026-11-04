# Architecture

## Hosting

The live tool is a published claude.ai artifact. claude.ai wraps `src/qe-health-check.html` in a document skeleton at publish time and serves it in a sandboxed frame. The page uses three runtime capabilities granted by claude.ai:

| Capability | Used for |
|---|---|
| `db` | The artifact's document database: saved assessments and the firm category library |
| `user` | Identifying the viewer (opaque id), checking whether they are an Editor, and showing names to practice leads |
| `downloads` | Saving exported reports and backups to the viewer's computer |

When these are unavailable (offline copy, signed-out viewer) the page still works: the current draft is kept in the browser's `localStorage`, and exports fall back to a normal download or a copy-to-clipboard panel.

## Data model

```
assess/<userId>                       One doc per QA lead: { items: { <assessmentId>: summary }, updatedAt }
assess/<userId>/items/<assessmentId>  Full assessment: { client, assessor, date, updatedAt, summary, state }
categories/<categoryId>               Firm category library: { def: category, updatedAt }
assessments/<id>                      Records saved before per-lead privacy (read-only to Editors)
```

`summary` holds the headline scores (`practice`, `target`, `ai`, `ready`) so the library lists assessments without loading every full record. `state` is the complete assessment as the page holds it: meta, outcomes, practice scores, targets, evidence notes, AI activity scores and delivery paths, readiness, preferences, custom categories, and N/A exclusions.

## Access rules

Declared with the artifact (claude.ai share levels: `interact` = Contributor, `admin` = Editor or owner):

```json
[
  { "path": "assess",        "read": "admin",    "write": "admin" },
  { "path": "assess/{self}", "read": "interact", "write": "interact" },
  { "path": "assessments",   "read": "admin",    "write": "admin" },
  { "path": "categories",    "read": "view",     "write": "admin" }
]
```

A QA lead reads and writes only their own `assess/<their id>` subtree. Editors read and manage all subtrees and the firm library. Everyone who can open the tool reads the firm library.

## Scoring

- **Category score** = mean of answered practice scores (N/A answers ignored).
- **Outcome weight** for a category or AI activity = 1 + the highest priority (0–3) among its linked client outcomes.
- **Gap item** = each practice (or AI activity) scored below its target. Impact score = gap × outcome weight; High ≥ 6, Medium 3–5, Low ≤ 2.
- **Horizon** comes from effort: Low → quick win (0–90 days), Medium → medium term (3–6 months), High → strategic (6–12 months). Low-impact items sit in each lane's backlog.
- **AI delivery path**: enablement and accelerator points are compared.
  - Enablement: +2 if a client tool covers the activity, +2 if the client wants to build its own capability (+1 for a mix), +1 if team AI skills ≥ 3, +1 if AI data access ≥ 3.
  - Accelerator: +2 if no client tool covers it, +2 if the client prefers ready-made (+1 for a mix), +1 if results are needed within 90 days, +1 if skills are low.
  - A difference of 2 or more picks the leader; otherwise hybrid. An accelerator gap counts as low effort, enablement and hybrid as medium; weak AI policy (≤ 2) raises effort one level and flags "policy first".
