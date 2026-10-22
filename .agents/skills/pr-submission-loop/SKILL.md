---
name: pr-submission-loop
description: Implement and submit a focused pull request, then address review and CI feedback through merge. Use for an end-to-end contribution or continued PR follow-up; schedule future runs only when requested.
---

# PR submission loop

## Establish the task

Read repository instructions and the current PR, if any. Resolve the target repository, fork/base branch, allowed scope, observable acceptance, and existing publication permissions. Preserve unrelated work. For scheduled follow-up, also record cadence, deadline or budget, authorized actions and stop conditions. Reuse approvals already supplied; ask only for missing inputs or authorization before dependent actions.

Check for overlapping work and distinguish an implementation or proof gap from a product, architecture, or ownership decision. Ask the responsible reviewer a concrete question early when that decision controls the work; follow the target repository's RFC policy rather than treating every bug fix as an RFC.

For OpenClaw core or OpenClaw Enterprise, read [review and coordination boundaries](references/openclaw-review-coordination.md). Recheck the linked live policy before applying repository-specific bot commands or routing rules. The two repositories do not have identical contribution policies or bot authority.

## Implement and submit

Start from current source in an isolated branch or suitable checkout. Make the smallest change, run relevant repository checks, and review the complete diff. Use independent review when it adds confidence. Keep static checks, runtime proof and historical evidence distinct; never claim unexecuted acceptance.

Make the PR easy to assess from its body: the reported behavior and expected result, the coherent change, proof at the owning boundary, and the remaining decision or limitation. Use the target's current template. Tie evidence to the tested head and environment; a successful older run, a mock, or a queued review is not a fresh runtime result.

Publish the authorized fork branch and PR. Explain the problem, resulting behavior, verification and remaining gaps. Read back the published head and diff. Preserve the same PR and published history; follow repository policy when updating from upstream.

If a publication result is uncertain, inspect remote state before retrying to avoid duplicate PRs, commits or replies.

## Repeat on meaningful change

1. Read fresh PR state, head SHA, upstream base, new or edited feedback, unresolved review threads and required checks. Check merge, closure, stop requests and deadline/budget before any mutation; route terminal states to cleanup below. Otherwise compare with the checkpoint.
2. If unchanged, update the checkpoint and end this run. Reuse checks, proof and reviews that remain valid; avoid duplicate delegates, builds, authentication retries and maintainer pings.
3. For actionable feedback, read the complete review as an action list, fix within scope, rerun affected checks, and refresh invalidated proof or review. If the base moved, assess compatibility before changing the branch. Publish authorized updates, verify the actual head and reply with evidence in authorized PR threads. Check the current review-trigger rules; do not assume a push or body edit queues another bot review. Request an allowed re-review only after the requested changes, body, proof and relevant CI are current, and avoid duplicate requests while queued.
4. If blocked on runtime access, host trust, publication or formal approval, name the specific gate. Continue independent authorized work. Automated review acceptance and green CI do not establish real behavior or formal approval. Use a permitted merge path only when authorized and all repository gates pass; otherwise await a maintainer.

Keep a durable checkpoint: PR URL, scope, branch/checkout, head/base SHAs, checks and proof provenance, processed feedback, remaining gates and decision owner, last review request/queue state, permissions, schedule and last check time. Keep credentials and private diagnostics out of public evidence.

## Coordinate a specific blocker

Keep the durable problem, change and evidence on the PR. When a human decision, cross-contributor coordination or apparently blocked automation needs community help, prepare one concise request containing the PR URL, current head/status, what changed or was tried, and the exact question or missing proof. Use the target's designated channel and any initiative-specific scope. Send only within the operator's outreach authorization; otherwise retain a draft. Do not use repeated pings, label changes or rating targets as a substitute for fixing the next actionable gap. Follow up when the state meaningfully changes or a reviewer asks.

## Schedule and finish

Create or update a follow-up only after an explicit request, using available scheduling controls in the same chat. Each run resumes this workflow with the checkpoint; the schedule grants no new permissions. Notify only on meaningful progress, failure, completion or required user action.

After GitHub confirms merge, record the merge commit and remove the follow-up. Also stop and remove it on closure without merge, an explicit stop request, or the agreed deadline/budget. Report an unmerged stop accurately; do not reopen or replace the PR without direction.
