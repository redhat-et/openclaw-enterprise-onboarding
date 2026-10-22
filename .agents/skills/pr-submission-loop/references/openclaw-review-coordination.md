# OpenClaw review and community coordination

Use this reference for OpenClaw core or OpenClaw Enterprise contributions. It separates the target repository's policy from observed community practices. Reviewed October 22, 2026; recheck live policy and the specific PR before acting. The observations below do not establish a guaranteed faster merge path.

## Use the target repository's policy

| Decision | OpenClaw core | OpenClaw Enterprise |
| --- | --- | --- |
| Contribution shape | Follow core's current contribution policy and PR template, including problem, user impact, rationale and evidence. Core's author-queue limits and triage rules apply to core. | Follow OCE's current template and policy. Ordinary fixes do not need an architectural RFC. Driver contract changes require RFC submission for human review before implementation; after submission, code and RFC review can proceed in parallel unless a specific decision or hold requires waiting. Keep incomplete implementation or proof in draft. |
| Review signal | Ratings and labels guide the next action; they are not fixed merge targets. A positive bot result is not maintainer approval. | Bot evidence, required CI, proof and human acceptance remain distinct. Read active CODEOWNERS and current rules; commented ownership entries and proposed maintenance settings are not active approval requirements. |
| Bot request | Core documents automatic review once on opening a non-draft PR or marking ready. Later pushes, body edits and reopens do not themselves requeue it. Authors can request `@clawsweeper re-review` or `@clawsweeper re-run` after changes, body, proof and relevant CI are current. A receipt may only mean queued. | Inspect OCE's current router profile. Its documented profile allows read/review/proof requests but rejects repair, implementation, autofix, automerge and merge-approval commands. Do not import core or historical bot privileges into OCE. |

Core's review-flow guide says to wait on a queued review and avoid overlapping an active human review or repair. It directs concrete automation or decision blockers to `#clawtributors`, with a PR link, status and specific question. Repeated requests or label changes do not make the queue faster. OCE may require a different responsible team or discussion; inspect the target's current guidance rather than treating a core channel or an author's anecdote as universal policy.

Policy sources, with reviewed revisions:

- [Core contribution policy](https://github.com/openclaw/openclaw/blob/fe2aa4a6c4443545b14a53c17c0b7e038d6111d5/CONTRIBUTING.md) and [review flow](https://github.com/openclaw/openclaw/blob/fe2aa4a6c4443545b14a53c17c0b7e038d6111d5/docs/reference/pull-request-review-flow.md).
- [OCE contribution policy](https://github.com/openclaw/openclaw-enterprise/blob/4b019d47b58f1fa617b9fa4451811c738bb4a783/CONTRIBUTING.md), [Driver contract RFC boundary](https://github.com/openclaw/openclaw-enterprise/blob/4b019d47b58f1fa617b9fa4451811c738bb4a783/AGENTS.md#submit-an-rfc-before-changing-a-driver-contract), [ClawSweeper dispatch boundary](https://github.com/openclaw/openclaw-enterprise/blob/4b019d47b58f1fa617b9fa4451811c738bb4a783/docs/flows/clawsweeper-dispatch.md) and [CODEOWNERS](https://github.com/openclaw/openclaw-enterprise/blob/4b019d47b58f1fa617b9fa4451811c738bb4a783/.github/CODEOWNERS).

## Practices observed in Discord

These are public-safe paraphrases of selected messages read on October 22, 2026, not transcripts or new maintainer rules. Discord links can require server access. The observations support clearer evidence and coordination; they do not measure causal effects on review speed.

| Observation | Reusable action | Scope and source |
| --- | --- | --- |
| A Focus Week opening post welcomed contributions without requiring a guest-team-server invitation and asked for GitHub issues/PRs, attempted/expected/observed behavior, reproduction and screenshots. | Put the actionable report on GitHub and link it from the relevant initiative with the requested evidence. | [October 19–25 Focus Week opening post](https://discord.com/channels/1456350064065904867/1561779378784964732/1561779378784964732). Named contacts and invitation arrangements belong to that dated initiative. |
| A readiness update distinguished PRs with real before/after Gateway evidence and no open findings from work needing a product/design decision. | Separate an evidence-ready change from a decision-dependent change, and name the remaining decision. | [Focus Week readiness and decisions](https://discord.com/channels/1456350064065904867/1561779378784964732/1561808511606857870). A status report, not formal approval for another PR. |
| An OCE RFC follow-up linked the PR, identified addressed feedback, and asked a human for a concrete component/status-code decision. | Ask the responsible human a bounded question with the current PR context. | [OCE RFC decision request](https://discord.com/channels/1456350064065904867/1506437854572580964/1562191059008749578). A request does not prove a decision or merge. |
| A community participant recommended critical independent review, expected review exchanges, and suggested filing an issue when unable to implement a change. | Use independent review when useful and provide a reproducible issue when implementation is not available. | [Community review advice](https://discord.com/channels/1456350064065904867/1506437854572580964/1513103757364297820). Participant advice, not a mandatory gate. |
| A contributor linked packaged-CLI/system-service proof and regression evidence while retaining restoration, upgrade and design limits. | Exercise the owning production boundary and keep unsupported cases visible in the same update. | [Packaged CLI proof and remaining limits](https://discord.com/channels/1456350064065904867/1458141495701012561/1558321522362294332). Reported case evidence does not qualify another environment. |
| A readiness/rebase update kept external-runtime scope separate. | Refresh the relevant base/checks and report the boundary the proof actually covers. | [Bounded readiness and runtime scope](https://discord.com/channels/1456350064065904867/1458141495701012561/1552377311788146761). A contributor report, not a general compatibility guarantee. |
| A participant reported fast bug-fix merges alongside other PRs becoming stale. | Seek agreement on direction and resolve the next concrete gate; do not promise timing from selected anecdotes. | [Mixed merge experiences](https://discord.com/channels/1456350064065904867/1458141495701012561/1560324365697159301). No measured or guaranteed fast track. |

## Apply the evidence without creating noise

Before asking for attention, make the branch, PR body, evidence and relevant CI current. Identify whether the next action belongs to the author, a reviewer, a product/architecture owner or queued automation. Address author-owned gaps directly. For a decision or coordination blocker, draft one request with the PR link, current state, what changed, and the exact question. Send it only when outreach is authorized; keep the durable answer on GitHub and update the PR body after a decision changes the proposal.

Do not claim ratings guarantee merge, use a contributor's message as permission for bot repair or merge commands, treat an initiative's guest invite as a contribution prerequisite, or use repeated pings to compensate for missing proof. Recheck the target's rules when a policy or automation boundary changes.
