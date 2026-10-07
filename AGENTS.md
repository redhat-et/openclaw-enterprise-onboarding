# Documentation contributor instructions

This repository publishes public onboarding for OpenClaw Enterprise. It contains documentation and a static site; it does not deploy infrastructure as part of documentation builds.

## When asked to set up OCE

Read `setup.md`, then `docs/GETTING_STARTED_AGENTS.md`, and carry out only the operator's requested local installation. `scripts/check-setup.sh` is a read-only first preflight. Documentation edits/site builds do not initiate deployment. Preserve local instructions, owned-resource isolation, explicit model/budget and private credentials. `llms.txt` is discovery; `llms-full.txt` is generated from the brief and runbook. `CLAUDE.md` imports this file rather than duplicating it.

Inventory existing VM/engine setups before creating one. This guide recommends an owned Lima VM with rootful Podman for new onboarding; the operator selected that path for this work, and the recorded repaired-source run passed platform/browser/model and full VM/cluster resume checks. It is not a company-wide runtime policy. Preserve an approved runtime choice already supplied in the session. Ask for missing runtime approval after inspection; do not create a VM or switch an existing machine's mode without authorization. Colima/Docker receipts remain historical evidence.

## Keep two versions

- `docs/GETTING_STARTED.md` is the concise human guide: next action first, five onboarding steps, commands linked to the runbook, explicit expected results.
- `docs/GETTING_STARTED_AGENTS.md` is the detailed operator/agent runbook: exact inputs, current source selection, private credential handling, acceptance, failure diagnosis and lifecycle.
- Update both when prerequisites, commands, models or capability boundaries change. Markdown is the authored source; keep any generated site synchronized through its build.
- Keep execution/discovery links synchronized. Graphs are self-contained SVGs in `docs/assets/`; do not add remote scripts/fonts or executable SVG content.

## Preserve evidence boundaries

Distinguish historical local verification, source-reviewed recipe and fresh reproduction. A login, Ready platform, successful resource creation or model's claimed tool action does not establish genuine Agent task acceptance. Do not label this development profile production-ready or claim full OpenShell integration.

Use current upstream `main` for new exploration and record its resolved SHA per installation. Pinned public source links document the reviewed contract and historical evidence; they do not require a stale checkout. Recheck manifests and changed commands when `main` advances. Keep upstream source checkout instructions separate from instructions for editing this onboarding repository. Read upstream `AGENTS.md` before modifying that product.

The fresh Lima/Fedora/Podman reproduction exposed a context-file helper mount failure and a separate k3d tagged-image import failure. [PR #1543](https://github.com/openclaw/openclaw-enterprise/pull/1543) addresses both; the repaired run passed onboarding and full VM/cluster resume. Follow the runbook's guarded current-main repair procedure when either reviewed fix is absent and record the base SHA plus exact repair identity. Apply only the needed Dockerfile and Go import changes; rebuild the CLI with `pnpm cli:build` before retrying. Do not report the repaired run as plain `main` acceptance or attribute the helper failure specifically to SELinux without evidence. Keep configured maximum effort separate from wire/billing measurement; tools were denied and not exercised, and resume verification sent no new test prompt.

## Publish only public-safe material

Do not add internal meeting notes, Slack links, private research, account identities, internal hostnames, real Agent IDs, kubeconfigs, keys, passwords, raw installation state, Pod environments or sensitive diagnostic receipts. Generic examples must use placeholders and owned resource names.

Credential inputs belong in private protected files or approved runtime injection, then platform Secrets. Never put secrets in Git, command arguments, logs, static site assets or agent prompts. Do not copy private repository history or ignored operator scripts into this repository.

## Check documentation changes

Use the repository's documented site build and link checks; inspect the rendered human and agent views. Do not add tests that only restate prose or run model inference/deploy infrastructure merely to verify a static presentation change. Record when a fresh deployment was not exercised.

Before publication, review the complete staged diff and built site for private material, broken paths, misleading provider compatibility, unsafe lifecycle commands and drift between the guide versions.
