# Set up OpenClaw Enterprise with a coding agent

> Execution brief for Claude Code, Codex, Cursor or another coding agent with local terminal access. Read this file, then follow the detailed runbook. Fetching it alone performs no installation.

Goal: an owned local OCE development platform, HTTPS sign-in and one verified model reply. This guide recommends Lima with rootful Podman for new onboarding. The CSB run passed official platform/database/native Codex/network checks, HTTPS sign-in and a GPT-6 Luna nonce/arithmetic response with maximum effort configured, using main baseline `e5e206c2a9de01601100c06581cc32f73a174456` plus [PR #1543](https://github.com/openclaw/openclaw-enterprise/pull/1543)'s repairs frozen at `a6bfbc985943bd79f49def459fdac13f18e06861`. Full cluster/VM resume preserved platform/database and exact Agent state/image/Ready Pod plus browser access, without a new model-response test prompt. The unmodified baseline failed. Tools were denied and not exercised; effort wire data and billing were not measured. Browser access used an approved exact local certificate exception, without claiming a CA import/system trust change. Earlier Colima and hosted-GLM receipts remain historical. New installations use current upstream `main`, with an exact SHA and any needed repair recorded for each run.

## 1. Read and inspect

Read [the detailed runbook](https://redhat-et.github.io/openclaw-enterprise-onboarding/GETTING_STARTED_AGENTS.md), especially Sections 1–2 and 9. Read applicable local `AGENTS.md` instructions before acting. Documentation builds alone do not request infrastructure setup.

Inspect OS/architecture, installed tools, memory/storage, existing VM/engine profiles and ports 3300/8444/6444. Read [the preflight script](https://redhat-et.github.io/openclaw-enterprise-onboarding/setup-check.sh) before running it, or perform its checks directly. It installs nothing, creates no VM/cluster and reads no credential. Use `--source` after cloning for toolchain requirements. Initial preflight inventories candidates. Once Lima is ready, use `--engine podman --podman-host 'unix://<owned host socket>' --require-lima` for bounded selected-engine rootful/cgroup checks. Without `--podman-host`, Podman remains CLI/profile inventory. For selected Docker use `--engine docker --docker-host 'unix://<owned host socket>'`; add `--require-colima` only for its optional historical recipe and require `docker buildx version`, not just a standalone `docker-buildx` binary. Engine metadata does not prove builds, image imports, mounts, forwarding or sandbox acceptance.

Inspect existing approved Linux VM/engine setups before creating another. Lima with rootful Podman is the recommended new-VM path selected and tested for this onboarding work, not company-wide runtime policy. Lima supplies Linux; Podman supplies the engine; k3d manages K3s inside engine containers. Preserve an approved runtime choice already supplied by the operator and verify it independently. The tested Lima recipe allocates 6 CPUs, 14 GiB RAM and an 80 GiB disk, with only the owned OCE work directory mounted writable. Earlier Colima receipts remain historical. Separately, roughly 60 GiB free host storage is planning headroom, not a tested minimum.

On company-managed/CSB devices preserve endpoint protection, host security policy, VPN/DNS and trust settings. If a required VM prerequisite is prohibited, report that blocker and use an approved environment. A local loopback route or VM does not exempt workloads from company policy.

## 2. Prepare an owned environment

Choose unused work/profile/cluster/state names and free ports. Preserve existing Docker/kubectl contexts, services and files. Follow the source block for current `main`, record `git rev-parse HEAD`, and derive Node/pnpm/Go from that checkout. Hold the selected checkout fixed while installing. Read upstream `AGENTS.md` before product edits. The Lima/Fedora/Podman reproduction found a context-file helper build failure and a separate k3d tagged-image import failure. Before startup, follow [Section 9's guarded current-main repair procedure](https://redhat-et.github.io/openclaw-enterprise-onboarding/GETTING_STARTED_AGENTS.md#temporary-repair-from-current-main) when either fix from [PR #1543](https://github.com/openclaw/openclaw-enterprise/pull/1543) is absent. It captures and reviews the public diff, checks both files before mutation, applies only the needed Dockerfile/Go changes and records the base plus repair identity. Both repairs passed the recorded onboarding run. Rebuild the CLI with `pnpm cli:build` before retrying. Do not claim plain `main` acceptance or relax SELinux to hide the helper failure.

After inspection, preserve the operator's existing approved runtime selection. For the recommended new environment follow Section 3's official `template:podman-rootful` Lima recipe. Ask for missing runtime approval before creating one or changing a machine's mode.

For Lima, unset `CONTAINER_CONNECTION`, export `CONTAINER_HOST` from the selected instance's host-forwarded Podman socket and give k3d the same endpoint as `DOCKER_HOST`. Mount only the owned work directory writable at its matching absolute guest path. Follow Section 3's one-time stopped-instance edit to preserve the Unix socket and permit only OCE's three loopback TCP forwards; changing ports requires updating that list and OCE's environment together. Do not register/change a default Podman connection. For selected Docker use its explicit host-reachable socket without changing the default context. Rootful Podman is an upstream-supported path with cgroup/socket requirements; changing an existing machine's rootful mode affects its storage and must be an intentional operator choice. Export the selected engine explicitly before startup. Keep generated state outside Git with restrictive permissions. The state directory itself must be absent at first startup; the cluster name must start with `occ-dev-`. Existing installations resume with `k3d cluster start`; `occ dev up` creates a fresh installation.

## 3. Install and verify the platform

Follow runbook Sections 3–5 with Kubernetes compute/control plane and `Sandbox Driver=none`. Run the official source-built launcher with all NetworkPolicy and native Codex sandbox checks retained. OpenShell is absent from this profile. Diagnose failures before retrying; apply the guest user-namespace prerequisite only for its established cause in the dedicated VM.

Require the official ready message, authenticated Installation access, platform `default` Namespace `ready`, `/readyz` HTTP 200, PostgreSQL StatefulSet rollout, bound database PVC, database query and Ready Pods, plus HTTPS console sign-in. Check the guest/daemon's DNS first, then diagnose node DNS separately from successful VM/engine image pulls; use only an approved reachable resolver when a repair/override is needed. Inspect the selected engine's actual guest storage mount (`DockerRootDir` for Docker) rather than `/var` alone. Report the console URL and private credential-file paths without reading passwords into tool output. Handle browser trust locally within company policy. A ready console does not establish model acceptance.

## 4. Configure one approved model and Agent

Use the operator's explicit provider/model and budget. Ask only for missing inputs; request a protected local key-file path or approved runtime injection, never a key pasted into chat. Do not invent credentials or silently select a paid model.

The reviewed upstream `first-agent.mjs` route uses direct OpenAI Responses, a plain model ID and no reasoning-effort option. An AI gateway key needs a separate console/API-managed Configuration with its approved URL, model ID, protocol and authentication. Section 6 includes an `openai/gpt-6-luna` / maximum-effort Configuration and complete linked resource flow. The Lima CSB run verified its exact admitted revision/Ready Pod and nonce/arithmetic model reply. Effort mapping was source-reviewed, with no wire or billing measurement; tools were denied and not exercised. Follow its compatibility checks; do not send a gateway key to the direct-provider helper. The hosted-GLM example is historical evidence for one Anthropic-Messages-compatible path, not a distributed gateway service or a current guarantee for another model.

Keep credential values out of commands, logs, configuration JSON, prompts and Git. Preserve Secret references and exact IAM grants. Tools/native admin UI are disabled in the direct OpenAI starter; enable and test tools only when separately requested. Current upstream emits a bounded `first-agent:` error on failure; diagnose selected resources instead of patching it to print raw command output.

## 5. Prove the outcome and hand off

Require `Model response verified:` and a real `Agent response:` for the intended active revision. Report **platform ready**, **prompt response verified**, or **native tool task verified** according to evidence. For prompt-only success, state that filesystem tools were not exercised. For tool claims, follow Section 7's native calls/results and independent file-byte checks; never write the expected file yourself.

Return a concise human result and detailed non-secret operator receipt: source/tools/model/protocol, owned profile/cluster/state paths, readiness/revision checks, browser URL, pause/resume commands and gaps. Leave the owned installation available unless asked to pause it. `occ dev down` is destructive teardown, not normal cleanup.

Full OpenShell, production/shared-cluster deployment, other architectures and broad model quality remain separate qualification tasks.

## Related files

- [Human guide](https://redhat-et.github.io/openclaw-enterprise-onboarding/GETTING_STARTED.md): concise overview.
- [Agent runbook](https://redhat-et.github.io/openclaw-enterprise-onboarding/GETTING_STARTED_AGENTS.md): exact commands and acceptance.
- [Discovery index](https://redhat-et.github.io/openclaw-enterprise-onboarding/llms.txt): small documentation map.
- [Complete agent packet](https://redhat-et.github.io/openclaw-enterprise-onboarding/llms-full.txt): generated brief plus runbook.
- [2026 reference research](https://redhat-et.github.io/openclaw-enterprise-onboarding/AGENT_SETUP_REFERENCES.md): primary-source examples and limits.
