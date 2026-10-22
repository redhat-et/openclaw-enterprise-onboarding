# Automated PR submission with Codex

Turn a real contribution into a repeatable skill: **scope → implement → verify → submit → review loop → maintainer merge → stop**. Codex handles implementation and follow-up; the contributor supplies direction and approvals, and the repository controls merge authority.

## Make the next review easy

Start with the target repository's current policy and PR template. Check for overlapping work, keep one coherent change, and make the problem, expected behavior, proof and remaining gap understandable from the PR body.

| Current gate | Useful next action |
| --- | --- |
| The author still owes a change or proof | Read the complete feedback, address the gap, rerun affected checks and update the body with evidence tied to the tested head. |
| The proposal needs a product, architecture or ownership decision | Ask the responsible human the specific question before expanding implementation. Follow that repository's RFC policy. |
| A review request is queued | Wait for the queued work; another ping or label change does not make it faster. Reuse checks that remain valid. |

The [OpenClaw/OCE reference](../.agents/skills/pr-submission-loop/references/openclaw-review-coordination.md) distinguishes current repository policy from selected Discord observations. The useful pattern is concrete GitHub context, real boundary proof and a clear remaining decision. The messages do not establish a guaranteed faster merge path. OpenClaw core and OCE have different bot and contribution boundaries; ratings are feedback, and positive automated review is not human approval.

## Coordinate a concrete decision

Keep the PR description as the durable summary. Use the target's designated community channel when a human decision, coordination problem or apparently blocked automation needs attention. A concise request can look like this:

```text
PR: <URL> · head: <SHA> · current state: <status>
Changed/tried: <the change or investigation since the last review>
Evidence: <focused checks or public proof, with remaining limits>
Question: <the exact decision, coordination need or missing proof>
```

Prepare the message as a draft unless outreach is already authorized. Consolidate the request and follow up on meaningful changes; avoid repeated pings or claims that a rating guarantees merge. A time-bound initiative may name contacts or invite guests to another server, but its arrangements are not universal contribution prerequisites.

After an update, check the bot's current trigger rules before assuming it will review again. Core documents a once-only automatic review and author-requested re-review after changes, description, proof and relevant CI are current. OCE's documented bot profile permits review/proof requests but rejects repair, autofix, automerge and merge-approval commands. Recheck the linked policy for the target before acting.

## Two cooperating loops

[![Historical PR 1537 workflow: contributor-controlled Codex loop exchanges updates and findings with repository-side review, followed by formal maintainer approval and merge](assets/pr-workflow/loop-comparison.png)](assets/pr-workflow/loop-comparison.png)

*Imagegen illustration of the historical PR #1537 workflow. The contributor owns fixes, evidence and scheduled follow-up; repository agents review the contribution. Formal approval remains a separate maintainer gate. Our Codex confirms merge and deletes its schedule; the CUA captures in this case were taken after merge.*

ClawSweeper's [historical README](https://github.com/openclaw/clawsweeper/blob/fb5a0d95b269f412aa185cf4deda1c115a83af69/README.md) identifies it as **OpenClaw-hosted**. OCE [dispatched PR events](https://github.com/openclaw/openclaw-enterprise/blob/4ba5eaa6d734c3dddb0ab88c2c35f884c10c429b/.github/workflows/clawsweeper-dispatch.yml) to that service. A [maintainer's clanker](https://github.com/openclaw/openclaw-enterprise/pull/1537#issuecomment-6023601427) separately reviewed scope and compatibility; its hosting is not established. This diagram records the October 2026 case, rather than promising current trigger behavior.

## What happened in PR #1537

[PR #1537](https://github.com/openclaw/openclaw-enterprise/pull/1537) made local console certificate-trust setup explicit. This distills the contributor's Codex chat and the public PR record.

| Contributor action | Codex action and result |
| --- | --- |
| Reported the browser certificate problem and requested an upstream PR through a fork. | Created a focused draft: three documentation files and one launcher message. |
| Requested review fixes, readiness, a local proof page, and certificate-only scope. | Fixed the [copied-CA path](https://github.com/openclaw/openclaw-enterprise/pull/1537#discussion_r4210880451), merged current main normally, and repaired a [documentation word-limit regression](https://github.com/openclaw/openclaw-enterprise/pull/1537#issuecomment-6045318835). |
| Asked for a two-hour loop until merge, then challenged stalled progress and token use. | Switched to compact change checks and a progress ledger; reused unchanged tests and reviews. |
| Approved the exact running CA for SSL trust, handled the OS prompt and browser restart, and requested final proof. | Verified warning-free navigation, password sign-in and authenticated reload. Published sanitized evidence, qualified as recovery of an existing installation. Historical startup evidence separately covered the launcher message. |
| Requested a corresponding issue and authorized a maintainer follow-up. | Linked issue #1735 and updated the [evidence and follow-up](https://github.com/openclaw/openclaw-enterprise/pull/1537#issuecomment-6059534539). |
| Left formal approval and merge to the maintainer. | Confirmed the merge and deleted the scheduled follow-up. |

The maintainer [approved](https://github.com/openclaw/openclaw-enterprise/pull/1537#pullrequestreview-5463239958) and merged on **October 9, 2026 at 05:49 Shanghai time** (October 8 at 21:49 UTC), merge commit `ddc5c804`. Green CI, automated review acceptance, demonstrated browser behavior, formal approval and merge were separate gates.

## The prompt and scheduled task

The original instruction, October 8, 2026:

> Do an 2-hour interval loop to address all comments by other agents until the PR is totally merged.

| Task record | Value |
| --- | --- |
| Name | Review OCE certificate PR |
| Cadence | Every two hours, continuing the same Codex chat |
| Work | Check new feedback, fix within scope, validate and publish authorized updates |
| Efficiency correction | If unchanged, checkpoint and wait; reuse valid tests and reviews |
| Stop | Confirm merge and delete the task; this happened after PR #1537 merged |

*Source: the original contributor chat. The completed task was deleted; no historical task-card or prompt screenshot was retained. This is a transcript-derived record, not a screenshot or a new active schedule.*

## Computer-use screenshots

These historical browser captures show Codex preparing outreach **after the PR merged**, separately from the review loop. Each pictured composer is an **unsent draft**. The full viewport is retained: Slack uses separate blur blocks over private text; Discord and LinkedIn retain their original background blur, with additional identity blocks obscured. Relevant draft content remains readable. These captures document draft preparation and do not establish delivery.

### Discord — unsent draft

[![Full-frame Discord capture with private context blurred and the outreach draft visible](assets/pr-workflow/discord-cua.png)](assets/pr-workflow/discord-cua.png)

*Historical post-merge computer-use demo. The draft remained unsent.*

### LinkedIn — unsent draft

[![Full-frame LinkedIn capture with recipient identity blurred and the message draft visible](assets/pr-workflow/linkedin-cua.png)](assets/pr-workflow/linkedin-cua.png)

*Historical post-merge computer-use demo. The draft remained unsent.*

### Slack — draft composer

[![Full Slack UI with private text blocks blurred and the Codex-prepared announcement draft visible](assets/pr-workflow/slack-cua.png)](assets/pr-workflow/slack-cua.png)

*Historical post-merge computer-use demo. A later private receipt verifies one parent post and three replies on October 13, 2026; this pictured draft does not establish delivery.*

## Use the skill

Copy the [pr-submission-loop skill](../.agents/skills/pr-submission-loop/SKILL.md) folder into `.agents/skills/` in the target repository. Keep its `SKILL.md` name, frontmatter and linked `references/` files together. Codex discovers repository skills there; see [official skill documentation](https://learn.chatgpt.com/docs/build-skills).

Start in the target repository with a concrete request:

```text
Use $pr-submission-loop to fix <problem> in <repository>.
Scope: <allowed changes>. Acceptance: <observable result>.
Publish a fork PR and address feedback in that PR's threads.
Keep a checkpoint with the head SHA, checks, proof and remaining gates.
Schedule a follow-up every two hours until merged; stay quiet if unchanged.
Reuse completed verification unless changes invalidate it.
Preserve existing approvals; ask only for missing authorization or inputs.
Leave merge to the maintainer. Stop and remove the follow-up after merge,
closure without merge, my stop request, or the agreed deadline/budget.
```

## Create the loop

1. **Write the skill.** Capture inputs, acceptance, the review cycle and stop conditions in `SKILL.md`; keep project-specific commands in the repository's instructions.
2. **Run the first contribution.** Inspect current source, implement the smallest change, validate it, review the diff, then publish the fork PR with evidence and remaining gaps.
3. **Schedule continuation.** After an explicit scheduling request, use Codex's scheduling control to continue the same chat. A skill stores instructions; the schedule supplies future runs. Record the PR, cadence, deadline or budget, authorized actions and cleanup rule.
4. **Check changes first.** Each run reads the current head, new or edited feedback, unresolved threads, required checks and merge state. No change means a checkpoint and the end of that run. New feedback means a focused fix, relevant verification, publication and readback.
5. **Close the loop.** Confirm GitHub reports a merge and its commit, then remove the schedule. If only approval is missing, report that gate when it changes; avoid repeated reviews, builds or pings.

Maintain this guide and its skill together. The Google Docs copy mirrors this published version; update it when the canonical Markdown changes.
