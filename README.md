# QE Health Check

A BrainRidge Consulting tool that QA leads use to run a first-hand current-state assessment of a client's QA practice. It scores maturity, captures where the client wants to be, maps AI adoption across the QA lifecycle, and produces a prioritized roadmap. For each AI activity it also recommends how BrainRidge should help: sell a BrainRidge AI accelerator, embed with the client team to build their capability, or both.

It is Phase 1 of the BrainRidge engagement model: **assess → quick wins → scale → re-assess**.

## What the assessment covers

| Step | What the QA lead captures |
|---|---|
| 1. Engagement | Client, delivery methodology, AI-DLC status, client AI tools, QA toolchain |
| 2. Client outcomes | Priority (High / Medium / Low) of nine outcomes. These weight every gap. |
| 3. QA practice | 36 practices in 9 categories across three pillars (test management, test data management, test environment management) and foundations, each scored 1–5 against a target. Custom categories can be added and any category can be marked N/A. |
| 4. AI across QA | Current and target AI adoption for 7 activities: requirement analysis, test design, test automation, test data, test and defect management in Jira, reporting, and CI/CD |
| 5. AI readiness | Policy, tool access, data access, skills, sponsorship, integration, plus the client's buy-vs-build preference and urgency |
| 6. Results | Maturity chart, pillar scores, recommended delivery path per AI activity, roadmap in three horizons, exports |

The full question set is in [docs/FRAMEWORK.md](docs/FRAMEWORK.md).

## Repository layout

```
src/qe-health-check.html     Source of the published claude.ai artifact (page content without the document skeleton)
dist/QE-Health-Check.html    Standalone copy that opens offline in any browser
docs/FRAMEWORK.md            The assessment framework, generated from the source
docs/ARCHITECTURE.md         How the tool works: hosting, data model, access rules, scoring
scripts/build-standalone.sh  Rebuilds dist/ from src/
scripts/generate-framework-doc.js  Regenerates docs/FRAMEWORK.md from src/
```

The whole tool is one HTML file with inline CSS and JavaScript. It has no build step, no dependencies and no server code.

## Two ways to run it

**1. Shared tool on claude.ai (recommended).** The live version is a claude.ai artifact owned by the QA practice. Assessments save to a shared database with access rules:

| Role (claude.ai share level) | Can do |
|---|---|
| QA lead (Contributor) | Run, save, reopen and re-assess their own assessments; add custom categories to an assessment; export reports |
| Practice lead (Editor) and owner | All of the above, plus see every QA lead's assessments, delete assessments, manage the firm category library, back up everything |

Everyone needs a BrainRidge Claude account (a member of the firm's Claude workspace), and the workspace admin must have artifact sharing turned on.

**2. Offline copy.** Open `dist/QE-Health-Check.html` in a browser. All scoring, roadmap and export features work. There is no shared library: save work with Export → Assessment file (.json) and reopen it with Import .json.

## Changing the tool

1. Edit `src/qe-health-check.html`. Framework content (categories, questions, AI activities, accelerators, tools, readiness questions) is in the `FRAMEWORK CONTENT` section at the top of the script.
2. Run `node scripts/generate-framework-doc.js` and `bash scripts/build-standalone.sh`.
3. Republish the artifact. Ask Claude to update the artifact using its claude.ai link and this file; the link and saved data stay the same.

Keep question and category `id` values stable. Saved assessments store scores by id, so renaming an id orphans existing scores.

## Backups

In the live tool, open **Saved assessments** and use **Full backup (.json)** or **Summary (.csv)**. Practice leads get every assessment and the firm category library; QA leads get their own. Store backups in the QA practice SharePoint.

## Ownership

The artifact belongs to its owner's claude.ai account. Keep at least one practice lead as an Editor so the tool stays managed if ownership changes, and keep this repository as the source of record.
