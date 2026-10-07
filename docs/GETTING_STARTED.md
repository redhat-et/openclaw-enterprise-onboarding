# OpenClaw Enterprise: start locally

**Start with [the tool checklist](GETTING_STARTED_AGENTS.md#2-prepare-the-tools-and-source).** Check the approved runtime on your Apple Silicon Mac before creating a VM.

**Goal:** sign in, deploy one Agent and get a real model reply. Allow **45–90 minutes** with prerequisites installed; this is a planning estimate. The Lima/rootful-Podman CSB run passed official platform/database checks, HTTPS sign-in and a GPT-6 Luna nonce/arithmetic response with maximum effort configured, using the recorded main baseline plus two repairs. Full VM/cluster pause and resume also passed. Filesystem tools were not exercised.

```text
Mac → Lima Linux VM → rootful Podman → k3d/K3s → OCE + Agent Pods
```

The VM supplies Linux; the engine runs containers; k3d creates K3s node containers. **Lima with rootful Podman is this guide's recommended new-VM path**, selected and tested for this onboarding work; it is not a company-wide runtime policy. Dogfooding exposed two [Podman compatibility failures](GETTING_STARTED_AGENTS.md#podman-build-helper-mount-failure); the recorded source repairs passed onboarding. Inspect existing environments first and preserve any approved runtime you already chose. The tested recipe allocates **6 CPUs, 14 GiB RAM and an 80 GiB VM disk**, with only the OCE work directory mounted writable. Separately allow roughly **60 GiB free Mac storage** for build headroom. These are planning values, not tested minimums. On CSB devices preserve security controls and use approved runtime, DNS and browser-trust settings.

## 1. Check your tools

You need Git, Bash, Python 3, Node, pnpm, Go, Lima, Podman, k3d, kubectl and Helm. Derive Node/pnpm/Go versions from the selected OCE checkout. Complete [the preflight](GETTING_STARTED_AGENTS.md#2-prepare-the-tools-and-source), including the selected Podman socket's rootful/cgroup checks. If you chose Docker, its separate checks require **`docker buildx version`** and `docker image save --platform` support.

## 2. Get the source and VM

Follow [the current source block](GETTING_STARTED_AGENTS.md#clone-current-source), then [the owned Lima/rootful-Podman recipe](GETTING_STARTED_AGENTS.md#recommended-owned-lima-vm-with-rootful-podman). It mounts only the work directory writable and limits automatic forwarding to OCE's three loopback TCP ports, while preserving Podman's Unix socket. New exploration uses upstream **`main`**; record its resolved SHA and any required repair for the run. Inspect approved existing environments before creating another. The runbook also covers reuse of Docker or a rootful Podman machine and preserves the historical Colima/Docker recipe.

**Expected:** a clean checkout and the selected engine responding through its explicit host socket/connection. Existing services and default contexts stay intact.

### Prefer your coding agent to do the setup?

Paste into Claude Code, Codex or Cursor with terminal access:

```text
Read https://redhat-et.github.io/openclaw-enterprise-onboarding/setup.md
and set up OCE on this Mac using the linked runbook. Inspect prerequisites and
existing runtimes; use the recommended Lima/rootful-Podman path unless I have already
selected another approved runtime. Ask for missing runtime approval or other inputs.
Preserve existing services, create an owned OCE cluster, and verify
HTTPS login and a real model reply. Use my approved model/budget and private
key-file input. Ask only for missing inputs; never request a key in chat.
```

[Agent discovery](https://redhat-et.github.io/openclaw-enterprise-onboarding/llms.txt) · [Complete packet](https://redhat-et.github.io/openclaw-enterprise-onboarding/llms-full.txt). The agent follows this same five-step guide. Click a diagram to open it at full size.

[![Agent-led setup from instructions to a verified model reply](assets/setup-flow.svg)](assets/setup-flow.svg)

[![Recommended Lima/rootful-Podman architecture: local OCE and remote model inference](assets/architecture.svg)](assets/architecture.svg)

## 3. Install OCE

Run [the installation block](GETTING_STARTED_AGENTS.md#4-install-the-kubernetes-profile) in the same terminal.

Before startup, follow [the guarded current-main repair procedure](GETTING_STARTED_AGENTS.md#temporary-repair-from-current-main) if either fix in [PR #1543](https://github.com/openclaw/openclaw-enterprise/pull/1543) is absent. It addresses the missing build helper and [k3d image-import socket failure](GETTING_STARTED_AGENTS.md#podman-tagged-image-import-failure), applies only the needed source changes and rebuilds the CLI. Both fixes passed the recorded Lima run; the unmodified baseline failed. Record any local patch instead of claiming plain-main success. Preserve SELinux and the official startup checks.

Wait for **“OpenClaw Enterprise development stack is ready.”** Keep generated credential files private. This explicitly selects Kubernetes compute/control plane and **`Sandbox Driver=none`**. The default Compose preview cannot deploy Agents; full OpenShell integration is a separate qualification. If startup fails, check [the selected socket, cgroups, guest/node DNS and sandbox prerequisites](GETTING_STARTED_AGENTS.md#9-diagnose-bounded-failures) before retrying.

## 4. Sign in

Open the **HTTPS console URL printed by startup**. Follow [the browser CA and readiness instructions](GETTING_STARTED_AGENTS.md#5-check-readiness-and-sign-in), using your approved CSB trust method or an approved exception for the verified exact local hostname. Sign in as `admin@development.openclaw.invalid` with the generated private password. The tested Lima and earlier Colima runs used local browser exceptions, without claiming a CA import/system trust change.

**Expected:** PostgreSQL rollout, its bound PVC and a database query pass; the platform Namespace **`default`** says **`ready`**. Port 3300 is a separate service-key API; password sign-in uses HTTPS.

## 5. Deploy and test one Agent

Choose your approved provider, exact model and budget. For a **direct OpenAI key**, use the same source checkout:

```bash
export OPENCLAW_FIRST_AGENT_MODEL='<approved direct OpenAI model ID>'
node scripts/first-agent.mjs onboarding-agent --prompt 'What is 2 + 2?'
```

Replace the placeholder before running. Enter your **direct OpenAI API key** at the private prompt, or use [a protected key file](GETTING_STARTED_AGENTS.md#6-deploy-the-upstream-first-agent). Never put the key in a command or chat.

For an **AI gateway key**, use a separate console/API-managed Agent. The runbook includes a [GPT-6 Luna maximum-effort configuration](GETTING_STARTED_AGENTS.md#openai-compatible-gateway-configuration-gpt-6-luna-maximum-effort) with an approved endpoint placeholder and private model Secret. The Lima CSB run verified its nonce/arithmetic reply and exact succeeded revision/Ready Pod. Tools were denied and not exercised; maximum effort was configured and source-reviewed, with no wire or billing measurement. The reviewed direct helper has no gateway URL or effort flag. Check [gateway compatibility](GETTING_STARTED_AGENTS.md#approved-gateway-models) before deployment.

**Done:** the direct helper prints **`Model response verified:`**, an **Agent response**, and the active revision. For a gateway-managed Agent require the same real model/revision evidence through its authenticated endpoint. Find that Agent in the console. A working console alone is not a model test. A bounded **`first-agent:`** error means proof has not passed; use the runbook's targeted checks.

This is upstream's documented **prompt-only** workflow; it was not the hosted GLM route used in the historical local run. The detailed runbook includes an [optional GLM example](GETTING_STARTED_AGENTS.md#optional-hosted-glm-example) and [genuine tool verification](GETTING_STARTED_AGENTS.md#7-verify-and-record-the-result).

## Pause without deleting your work

Restore the selected engine's host endpoint using [the lifecycle instructions](GETTING_STARTED_AGENTS.md#8-pause-resume-or-discard), then:

```bash
k3d cluster stop "$OCC_DEVELOPMENT_KUBERNETES_CLUSTER"
```

[VM stop/resume instructions](GETTING_STARTED_AGENTS.md#8-pause-resume-or-discard) follow the runtime you selected. Keep a reused/shared VM running for unrelated workloads. **`occ dev down` deletes the installation and its data.**

**Next:** complete Step 1's tool checklist.
