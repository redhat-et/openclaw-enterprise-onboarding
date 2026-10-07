# OpenClaw Enterprise: detailed local runbook

**Execute the preflight in Section 2, then follow the sections in order.** Use the [human guide](GETTING_STARTED.md) for the five-step overview.

Updated October 7, 2026. This guide recommends an owned Lima VM with rootful Podman for new onboarding, as selected and tested for this work; this is not a company-wide runtime policy. The CSB Mac reproduction passed official startup/network/native Codex checks, PostgreSQL/API readiness, HTTPS administrator sign-in and a genuine embedded GPT-6 Luna gateway nonce/arithmetic response with maximum effort configured. It used the then-current `main` baseline `e5e206c2a9de01601100c06581cc32f73a174456` plus both repairs in [PR #1543](https://github.com/openclaw/openclaw-enterprise/pull/1543), frozen at `a6bfbc985943bd79f49def459fdac13f18e06861`. The unmodified baseline failed; this is **main plus recorded repairs**, not plain-main acceptance. Full cluster/VM stop and resume preserved platform/database readiness, the exact Agent revision/configuration/image and HTTPS browser access; resume verification sent no new test prompt.

New exploration starts from current upstream `main`; record its resolved SHA and any still-needed repair. The model test verified the nonce and **437** response, matching Ready Pod and succeeded revision. Filesystem tools were denied and not exercised; effort wire data and billing were not measured. Browser access used an operator-approved exact local certificate exception; no CA import/system trust change is claimed. SELinux remained Enforcing, with no DNS override or guest sysctl/managed-host relaxation. Official scoped node seccomp preparation passed. Earlier Colima/Docker runs at `8023db20d5a7cfa84dbfe734d43898fc8cc354ce` and the October 1 hosted-GLM tool task remain historical evidence. Sensitive receipts are not published. Qualify each new installation independently.

## 1. Select the development profile

```text
Apple Silicon Mac → Lima Linux VM → rootful Podman → k3d/K3s
  → PostgreSQL + OCE API/worker + Envoy Gateway/cert-manager → Agent Pods
```

OCE means **OpenClaw Enterprise**; OCC means **OpenClaw Control Plane**. The Mac runs the platform and tools; provider models run remotely.

[![Recommended Lima/rootful-Podman path with k3d/K3s, OCE services, tenant Agent and remote inference boundaries](assets/architecture.svg)](assets/architecture.svg)

Click any diagram to open its full-size SVG; the text remains the executable reference.

| Input | October 7 Lima/Podman verified onboarding receipt |
| --- | --- |
| OCE source baseline | `e5e206c2a9de01601100c06581cc32f73a174456`; unmodified runtime build failed |
| Source compatibility repairs | [PR #1543](https://github.com/openclaw/openclaw-enterprise/pull/1543), frozen at `a6bfbc985943bd79f49def459fdac13f18e06861`; helper copy and Podman archive/direct import |
| Owned VM | Lima `2.2.1`; VZ/aarch64; 6 CPUs; 14 GiB RAM; 80 GiB disk |
| Observed guest | Fedora `44`; kernel `6.19.10-300.fc44.aarch64` |
| Podman | Host CLI `5.4.1`; guest server `5.8.7`; rootful; cgroup v2 with `cpuset` |
| Kubernetes | K3s `v1.36.4+k3s1`; selected by the official launcher, not an independent installation pin |
| Storage/network | Overlay at `/var/lib/containers/storage` on the guest root disk; netavark |
| Guest security/mount | SELinux Enforcing; native user namespace check passed without sysctl changes; only the owned OCE work directory mounted writable at its matching absolute path |
| Platform/browser | Official launcher/network/native Codex checks; PostgreSQL StatefulSet/PVC/query; API/default Namespace readiness; verified TLS and HTTPS sign-in |
| Model | Embedded `openai/gpt-6-luna`, OpenAI Responses, `thinkingDefault=max`; nonce and **437** response; exact succeeded revision and Ready Pod; no filesystem tools |
| Pause/resume | k3d stop → Lima stop/start → k3d start; database/platform and exact Agent state/image/Pod plus browser access persisted; no new test prompt |
| Handoff | Smoke Agent stopped after verification; platform/console and saved Configuration retained |

k3d documents its [Podman integration as experimental](https://k3d.io/stable/usage/advanced/podman/). The recommendation covers this owned development recipe and its recorded acceptance, rather than universal Podman compatibility.

| Input | October 1 historical working selection |
| --- | --- |
| OCE source | `affac2bfc1370e590e6da570bcaaad4a207c9f09` |
| Runtime OpenClaw source, selected by its Dockerfile | `9d9c8568c51e340540f634f71bd7c7582a70debc` |
| Runtime Codex engine | `0.158.0` |
| Toolchain | Node >=24; pnpm `11.15.1`; Go `1.27` (observed `1.27.1`) |
| Kubernetes | k3d `5.9.0`; K3s `v1.36.4+k3s1`; containerd `2.3.4`; kubectl `1.36.4` |
| Container tools | Docker daemon `29.5.2`; Docker CLI `29.8.1` |
| Dedicated VM | Colima VZ/aarch64; 6 CPUs; 14 GiB RAM; 45 GiB sparse disk |
| Observed guest | Ubuntu `24.04.4`; kernel `6.8.0-117-generic` |
| Platform dependencies | PostgreSQL `18.6`; cert-manager `1.18.4`; Envoy Gateway `1.6.7` |

Select Kubernetes compute and control plane with **`Sandbox Driver=none`**. This profile does not install or qualify OpenShell enforcement/credential brokering. Native Codex workspace sandboxing is a separate boundary. Default startup selects a Compose preview that cannot deploy Agents; the Compose/Kubernetes hybrid also differs from this recipe.

The table records history, not mandatory install versions. Prefer current `main` while OCE is changing quickly: older commits can miss startup and database fixes. Record the new SHA, derive its toolchain from `package.json`/`go.mod`, and hold that checkout fixed throughout one installation. Recheck [current upstream setup](https://github.com/openclaw/openclaw-enterprise/blob/main/docs/guides/quickstart.md) if `main` advances beyond the [reviewed profile contract](https://github.com/openclaw/openclaw-enterprise/blob/e5e206c2a9de01601100c06581cc32f73a174456/docs/guides/deploy/local-kubernetes-development.md). Pinned links below identify reviewed evidence; clone commands do not pin the historical SHA. Kubernetes-only startup selects its own K3s image; do not independently choose a K3s channel from another profile.

### Company-managed/CSB boundary

Use the organization's approved VM/runtime, network egress, model gateway and credential handling. Preserve endpoint protection, host security policy, VPN/DNS and unrelated services. Security alerts or terminated workloads need the organization's approved resolution; do not disable an endpoint sensor or change the Mac's protection settings. Loopback publication and an owned VM do not establish compliance approval.

The conditional guest sysctl in Section 9 changes a Linux VM's policy. Apply it only if the cause is established and the organization permits that prerequisite. Otherwise use an approved compatible development VM or remote environment and report the local blocker. Do not install experimental OpenShell components merely to work around a failed Kubernetes-only startup.

## 2. Prepare the tools and source

### Agent-led setup entry point

If an operator asks your coding agent to install OCE, read [setup.md](https://redhat-et.github.io/openclaw-enterprise-onboarding/setup.md) and continue this runbook in order. The [llms.txt index](https://redhat-et.github.io/openclaw-enterprise-onboarding/llms.txt) discovers the files; [llms-full.txt](https://redhat-et.github.io/openclaw-enterprise-onboarding/llms-full.txt) combines the brief and runbook for one fetch. These files guide execution; they do not execute on retrieval. Use terminal-capable Claude Code, Codex, Cursor or an equivalent agent.

Read the [preflight script](https://redhat-et.github.io/openclaw-enterprise-onboarding/setup-check.sh) before running it. From this onboarding repository use `bash scripts/check-setup.sh`. It inventories host/tools, storage, ports and existing runtime profiles without choosing an engine, installing or reading credentials. After cloning, add `--source '<OCE checkout>'` to check manifest requirements. For the recommended Lima path, use `--engine podman --podman-host 'unix://<owned host socket>' --require-lima` after the VM is ready. This checks only that explicitly selected local socket, including rootful/cgroup prerequisites. Without `--podman-host`, selected Podman remains CLI/profile inventory and daemon acceptance is pending. For selected Docker use `--engine docker --docker-host 'unix://<owned host socket>'`; add `--require-colima` only for the optional historical Colima recipe. The script changes no context and creates no VM/cluster.

[![Agent execution flow from discovery and inspection to owned installation and verification](assets/setup-flow.svg)](assets/setup-flow.svg)

Install Git, Bash, Python 3 for the preflight, the checkout's Node/pnpm/Go versions, k3d, kubectl and Helm. For the recommended path install approved Lima and Podman host CLI packages. Use native arm64 tools on Apple Silicon. The current October 7 reviewed checkout requires Node >=24, pnpm `11.15.1` and Go >=`1.27`; verify these manifests again rather than assuming they remain current. For Docker, the CLI must support `docker image save --platform` and expose its Buildx plugin through `docker buildx version`. Kubernetes-only startup does not need Docker Compose. A standalone `docker-buildx version` does not establish that Docker can find the plugin.

Check the **executable actually selected by `PATH`**, not just an installed package. For example, an approved Homebrew `node@24` installation can coexist with a stale default `node` symlink; in that case add its `bin` directory to this shell's `PATH` and rerun `node --version`. Do not replace global symlinks or install another toolchain before inspecting the existing one.

Plan **45–90 minutes**, including first downloads, builds and Agent startup; this is an estimate. The tested Lima recipe allocates **6 CPUs / 14 GiB RAM / 80 GiB disk**; these are not minimums. The earlier October 7 Colima run used a 60 GiB disk; the table retains its older 45 GiB disk as historical evidence. A 4 GiB engine allocation failed the runtime build. Separately allow roughly **60 GiB free host storage** for build headroom. At the reviewed revision an Agent Gateway requests `1792Mi` and has a `3Gi` limit; a dedicated Codex Harness adds a `768Mi` request and `6Gi` limit. Check [current sizing](https://github.com/openclaw/openclaw-enterprise/blob/main/docs/guides/deploy/installation-profiles.md) before creating more Agents.

Inspect installed tool versions, Colima/Lima/Podman profiles, Docker contexts and ports **3300, 8444, 6444**. Choose distinct names/ports if occupied. Preserve existing default Docker/kubectl contexts and unrelated services. Do not auto-start every discovered runtime or auto-switch an existing Podman machine's mode.

### Clone current source

Run in Bash; choose an unused work directory. Private state will live beside, outside, the source checkout.

```bash
set -euo pipefail
umask 077
export OCE_WORK="$HOME/oce-onboarding-dev"
mkdir -p "$OCE_WORK"
git clone --branch main --single-branch https://github.com/openclaw/openclaw-enterprise.git \
  "$OCE_WORK/openclaw-enterprise"
cd "$OCE_WORK/openclaw-enterprise"
git rev-parse HEAD
git status --short
node --input-type=module <<'NODE'
import { readFileSync } from 'node:fs';
const manifest = JSON.parse(readFileSync('package.json', 'utf8'));
console.log('Node:', manifest.engines.node);
console.log('pnpm:', manifest.packageManager);
console.log(readFileSync('go.mod', 'utf8').match(/^go\s+\S+/m)?.[0]);
NODE
node --version
pnpm --version
go version
```

Require a clean initial checkout and tool versions compatible with the printed manifests. Record `git rev-parse HEAD` in the private receipt before installation. Read the checkout's `AGENTS.md` before source changes. Complete this section's toolchain, frozen dependency install and CLI build, then follow [the temporary Podman source repair](#temporary-repair-from-current-main) before Section 4 when either fix is absent from current `main`. It captures and reviews [PR #1543](https://github.com/openclaw/openclaw-enterprise/pull/1543), applies only the needed runtime Dockerfile and Go image-import changes and records the baseline plus patch identity. Both fixes passed the recorded Lima reproduction; each new installation still requires acceptance. Rebuild the CLI after the Go change. Use the declared pnpm version; do not edit the lockfile to fix a host toolchain failure. For an existing clean exploration checkout, update deliberately with `git pull --ff-only` before a fresh installation, then record the new SHA. Never pull or rebuild midway through a running installation and treat it as an upgrade.

Use an existing matching package manager when available. If the declared pnpm needs an approved installation, this keeps it in the task's private tool prefix and preserves the global pnpm:

```bash
export OCE_PACKAGE_MANAGER="$(node -p 'require("./package.json").packageManager.split("+")[0]')"
case "$OCE_PACKAGE_MANAGER" in pnpm@*) ;; *) exit 1 ;; esac
mkdir -p "$OCE_WORK/private"
chmod 700 "$OCE_WORK/private"
npm install --prefix "$OCE_WORK/private/tools" --no-audit --no-fund \
  "$OCE_PACKAGE_MANAGER"
export PATH="$OCE_WORK/private/tools/node_modules/.bin:$PATH"
```

An npm local prefix exposes its executable in **`node_modules/.bin`**, not `tools/bin`. A global pnpm can auto-download/switch versions for a project, masking which executable was selected. Verify without implicit package-manager downloads, then install the frozen dependencies and build:

```bash
export npm_config_manage_package_manager_versions=false
export COREPACK_ENABLE_AUTO_PIN=0
export COREPACK_ENABLE_NETWORK=0
export OCE_PNPM_VERSION="$(node -p 'require("./package.json").packageManager.split("+")[0].slice("pnpm@".length)')"
test "$(pnpm --version)" = "$OCE_PNPM_VERSION"
pnpm install --frozen-lockfile
pnpm cli:build
```

## 3. Choose the VM and container engine

Inspect existing runtime profiles, engine connections, architecture, available resources, mounts and ownership. Preserve an operator-selected approved runtime. For a new owned environment, this guide recommends the tested **Lima with rootful Podman** recipe. Obtain any missing runtime approval before creation. Do not start a second VM automatically or switch an existing machine's mode.

| Layer | Purpose and selection |
| --- | --- |
| Linux VM on macOS | Lima supplies the guest Linux OS in the recommended path. Other approved existing environments may use Colima, Docker Desktop or a Podman machine; inspect their actual resources and host socket/connection. |
| Container engine | Rootful Podman runs containers inside the Lima guest. Docker and rootful Podman are upstream-supported engine paths; each environment needs its own acceptance. |
| k3d | Creates owned K3s node containers in that engine. It is not the Linux VM or container engine. Let the OCE launcher create its cluster. |
| K3s | Kubernetes inside the node containers. Avoid starting a separate VM-manager Kubernetes cluster or attaching this development launcher to an unrelated cluster. |

Give OCE distinct cluster/state/ports even when reusing an engine. Do not stop or reconfigure a shared VM to repair OCE. The recommended recipe creates an owned Lima instance; the reuse paths below preserve an approved existing choice.

### Recommended owned Lima VM with rootful Podman

Use the [official Lima Podman recipe](https://lima-vm.io/docs/examples/containers/podman/) with **`template:podman-rootful`**. The reviewed Lima 2.2.1 template uses a Fedora guest, installs rootful Podman and forwards `/run/podman/podman.sock` to the instance's host socket. Record the actual Lima/guest/Podman versions after creation. Rootful applies inside the VM; run host commands as your normal macOS user. Do not use the rootless Podman template for K3s, which needs the `cpuset` cgroup controller.

Use an unused instance name and the work directory from Section 2. Mount **only that owned directory writable**, at the same absolute guest path, so the source/private state required by the launcher is visible to Podman. Do not make the whole home directory writable. Lima's default read-only home mount can otherwise cause [filesystem-is-not-writable failures](https://lima-vm.io/docs/faq/#filesystem-is-not-writable).

```bash
export OCC_DEVELOPMENT_CONTAINER_ENGINE=podman
export OCE_LIMA_INSTANCE='oce-onboarding'
limactl start --name "$OCE_LIMA_INSTANCE" \
  --arch aarch64 --vm-type vz --cpus 6 --memory 14 --disk 80 \
  --mount-only "${OCE_WORK}:w" --tty=false template:podman-rootful

# Configure forwarding once, before creating any OCE cluster.
limactl stop "$OCE_LIMA_INSTANCE"
limactl edit "$OCE_LIMA_INSTANCE" --tty=false --set \
  '.portForwards += [{"guestIP":"127.0.0.1","guestPort":3300,"hostIP":"127.0.0.1","hostPort":3300,"proto":"tcp"},{"guestIP":"127.0.0.1","guestPort":8444,"hostIP":"127.0.0.1","hostPort":8444,"proto":"tcp"},{"guestIP":"127.0.0.1","guestPort":6444,"hostIP":"127.0.0.1","hostPort":6444,"proto":"tcp"},{"guestIP":"0.0.0.0","guestIPMustBeZero":false,"guestPortRange":[1,65535],"proto":"any","ignore":true}]'
limactl start --tty=false "$OCE_LIMA_INSTANCE"

unset DOCKER_CONTEXT DOCKER_TLS_VERIFY DOCKER_CERT_PATH DOCKER_HOST
unset CONTAINER_CONNECTION CONTAINER_HOST
CONTAINER_HOST="$(limactl list "$OCE_LIMA_INSTANCE" \
  --format 'unix://{{.Dir}}/sock/podman.sock')"
export CONTAINER_HOST
export DOCKER_HOST="$CONTAINER_HOST"
podman --remote --url "$CONTAINER_HOST" version
OCE_PODMAN_ROOT="$(podman --remote --url "$CONTAINER_HOST" info \
  --format '{{.Store.GraphRoot}}')"
limactl shell "$OCE_LIMA_INSTANCE" df -h / "$OCE_PODMAN_ROOT"
```

Use the filtered instance query: listing every instance can concatenate unrelated socket paths. `CONTAINER_HOST` is Lima's **host-forwarded** API socket, not a guest-only path reported by `podman info`. Keep `CONTAINER_CONNECTION` unset so a saved named connection cannot override it. `DOCKER_HOST` gives k3d the same Podman Docker-compatible endpoint; it does not select a Docker daemon. Do not add/change the default Podman connection or Docker context from the template's convenience message.

The forwarding edit appends to the fresh template **once** while the instance is stopped. It preserves the Podman Unix-socket rule, permits only OCE's three loopback TCP ports and ignores all other automatic TCP/UDP forwarding. `guestIPMustBeZero:false` makes the final rule cover loopback services as well as wildcard listeners. The stop/edit/start sequence and responding Podman socket were verified; the three OCE port listeners will be checked after platform startup. If you choose different OCE ports, change both these rules and Section 4's environment values. Resuming an instance does not repeat this edit. See [Lima's forwarding rule contract](https://github.com/lima-vm/lima/blob/v2.2.1/templates/default.yaml#L513-L560).

From the onboarding repository, rerun the reviewed preflight with `--source "$OCE_WORK/openclaw-enterprise" --engine podman --podman-host "$CONTAINER_HOST" --require-lima`. Require a responding rootful engine, cgroup v2 with `cpuset`, guest-visible work/state paths and adequate capacity on Podman's actual storage mount. A running VM or successful `podman version` alone does not establish installation acceptance. Leave any prior DNS override unset unless fresh node diagnosis requires an approved reachable resolver.

### Reuse an approved rootful Podman machine

Follow [upstream rootful Podman requirements](https://github.com/openclaw/openclaw-enterprise/blob/e5e206c2a9de01601100c06581cc32f73a174456/docs/guides/deploy/local-kubernetes-development.md#start-the-profile). Native rootless Podman cannot start this profile because K3s needs the `cpuset` controller. Use an approved **rootful** machine as the normal macOS user; never run host `sudo podman` to approximate this. Rootful/rootless storage is separate, so changing an existing machine affects its environment.

For an explicitly selected approved rootful machine, use its recorded host connection and export the selected engine:

```bash
unset DOCKER_CONTEXT DOCKER_TLS_VERIFY DOCKER_CERT_PATH DOCKER_HOST CONTAINER_HOST
export CONTAINER_CONNECTION='<selected approved rootful machine connection>'
export OCC_DEVELOPMENT_CONTAINER_ENGINE=podman
```

Replace the connection placeholder before running. Let upstream resolve the machine's host API socket; `podman info` can report a guest-only path, which is invalid as host `DOCKER_HOST`/`CONTAINER_HOST`. Retain the connection and any approved `CONTAINERS_CONF_OVERRIDE` for cleanup. This Podman-machine path differs from the dedicated Lima recipe; independently verify it. Do not uninstall Podman or change organizational runtime policy to use these docs.

### Selected existing Docker environment

Inspect `docker context ls` and the intended context's **non-secret** endpoint, or your VM manager's documented socket. Select its actual host-reachable local Unix socket:

```bash
export OCC_DEVELOPMENT_CONTAINER_ENGINE=docker
unset DOCKER_CONTEXT DOCKER_TLS_VERIFY DOCKER_CERT_PATH DOCKER_HOST
export DOCKER_HOST='unix://<approved existing host socket>'
docker version
docker info --format '{{.OSType}}/{{.Architecture}}; memory={{.MemTotal}}'
docker buildx version
docker image save --help
```

Replace the socket placeholder before running. Keep using that explicit endpoint in every OCE/k3d lifecycle shell. Check `docker info --format '{{.DockerRootDir}}'` and inspect that **guest path's backing filesystem** using the selected VM manager. For example, run `colima --profile '<existing-profile>' ssh -- df -h / '<DockerRootDir>'` or `limactl shell '<existing-instance>' df -h / '<DockerRootDir>'`. Colima can mount a separate Docker data disk: checking only `/var` can report the smaller guest root disk and miss the actual image-storage capacity. Reuse does not qualify a different kernel/runtime automatically.

### Historical Colima/Docker recipe

Use this block only if the operator explicitly chooses a new owned Colima/Docker profile. It records the earlier October 1/7 tested path. Lima/rootful Podman is the recommended new-VM path.

```bash
export OCC_DEVELOPMENT_CONTAINER_ENGINE=docker
export OCE_PROFILE='oce-onboarding'
colima --profile "$OCE_PROFILE" start \
  --arch aarch64 --vm-type vz --runtime docker \
  --cpus 6 --memory 14 --disk 60 \
  --activate=false --ssh-config=false

unset DOCKER_CONTEXT DOCKER_TLS_VERIFY DOCKER_CERT_PATH DOCKER_HOST
export DOCKER_HOST="unix://$HOME/.colima/$OCE_PROFILE/docker.sock"
docker version
docker info --format '{{.OSType}}/{{.Architecture}}; memory={{.MemTotal}}'
docker buildx version
docker image save --help
export OCE_DOCKER_ROOT="$(docker info --format '{{.DockerRootDir}}')"
colima --profile "$OCE_PROFILE" ssh -- df -h / "$OCE_DOCKER_ROOT"
```

Require the selected daemon to respond, Buildx to be a Docker CLI command, and `image save` help to list `--platform`. The socket assumes Colima's default home; customized `COLIMA_HOME` requires its actual host-reachable socket. Do not copy a guest-only socket path. `--activate=false --ssh-config=false` preserves default context/SSH settings. These exports affect only this shell; do not run `docker context use` or `kubectl config use-context`.

Other VM/engine and host combinations require their own acceptance. The October 7 receipt establishes this Lima/rootful-Podman recipe with the recorded source repairs; earlier October 1/7 receipts establish the Colima VZ/Docker Apple Silicon example. Docker Desktop, other Podman-machine profiles, Intel Mac and Linux variants remain separately qualified.

## 4. Install the Kubernetes profile

Create only the private parent. **The state directory itself must be absent** for fresh startup. Cluster names must start with `occ-dev-`.

```bash
mkdir -p "$OCE_WORK/private"
chmod 700 "$OCE_WORK/private"
export OCC_DEVELOPMENT_STATE_DIRECTORY="$OCE_WORK/private/onboarding-state"
export OCC_DEVELOPMENT_KUBERNETES_CLUSTER='occ-dev-oce-onboarding'
export OCC_DEVELOPMENT_COMPUTE_DRIVER=kubernetes
export OCC_DEVELOPMENT_CONTROL_PLANE=kubernetes
export OCC_DEVELOPMENT_SANDBOX_DRIVER=none
: "${OCC_DEVELOPMENT_CONTAINER_ENGINE:?Select docker or podman in Section 3 first}"
case "$OCC_DEVELOPMENT_CONTAINER_ENGINE" in
  docker|podman) ;;
  *) printf '%s\n' 'Select an approved docker or podman path in Section 3.' >&2; exit 1 ;;
esac
export OCC_DEVELOPMENT_KUBERNETES_NAMESPACE=oce-system
export OPENCLAW_DEV_PORT=3300
export OCC_DEVELOPMENT_BROWSER_PORT=8444
export OCC_DEVELOPMENT_KUBERNETES_API_PORT=6444
export OCC_DEVELOPMENT_STARTUP_TIMEOUT_SECONDS=600
unset OCC_DEVELOPMENT_CONTROLLER_IMAGE OCC_KUBERNETES_RUNTIME_IMAGE
./bin/occ dev up
```

Require **`OpenClaw Enterprise development stack is ready.`** The launcher builds/imports matched source images, installs the platform and generates private state. It performs NetworkPolicy acceptance and checks the dedicated Codex sandbox against the imported runtime before declaring success.

The source build avoids assuming published registry access. For an intentional published-image alternative, follow [current upstream image selection](https://github.com/openclaw/openclaw-enterprise/blob/main/docs/guides/deploy/published-images.md): select controller/runtime together, match the source revision labels to the checkout and record immutable digests. A `latest` image pair can select a different source revision from current `main`; do not mix them. Local build digests are not promised as downloadable images.

Keep passwords, service keys, kubeconfig and TLS private keys private. Do not publish state/Helm values/Installation YAML, full Secret objects, Pod environments or native auth files. The state directory is `0700`; keep it outside Git. A startup failure may roll back the owned cluster; use the printed cleanup instruction for retained failed state, then resolve the cause before retrying.

## 5. Check readiness and sign in

PostgreSQL holds OCE's platform state, including IAM grants and resource/revision records. The official launcher provisions it inside the owned k3d cluster. Verify that database before creating an Agent or diagnosing a first-Agent IAM error.

```bash
export OCC_URL="http://127.0.0.1:$OPENCLAW_DEV_PORT"
export OCC_SERVICE_KEY_FILE="$OCC_DEVELOPMENT_STATE_DIRECTORY/initial-admin-service-key.json"
export OCE_KUBECONFIG="$OCC_DEVELOPMENT_STATE_DIRECTORY/kubeconfig"
export OCE_CONTEXT="k3d-$OCC_DEVELOPMENT_KUBERNETES_CLUSTER"
export OCE_PLATFORM_NAMESPACE="$OCC_DEVELOPMENT_KUBERNETES_NAMESPACE"
./bin/occ installation get
./bin/occ namespace list
curl --fail --max-time 10 "$OCC_URL/readyz"
kubectl --kubeconfig "$OCE_KUBECONFIG" --context "$OCE_CONTEXT" get pods -A
kubectl --kubeconfig "$OCE_KUBECONFIG" --context "$OCE_CONTEXT" \
  -n "$OCE_PLATFORM_NAMESPACE" get statefulset/postgres pvc/postgres-data
kubectl --kubeconfig "$OCE_KUBECONFIG" --context "$OCE_CONTEXT" \
  -n "$OCE_PLATFORM_NAMESPACE" rollout status statefulset/postgres --timeout=120s
kubectl --kubeconfig "$OCE_KUBECONFIG" --context "$OCE_CONTEXT" \
  -n "$OCE_PLATFORM_NAMESPACE" exec statefulset/postgres -c postgres -- \
  pg_isready -U postgres -d openclaw_enterprise
kubectl --kubeconfig "$OCE_KUBECONFIG" --context "$OCE_CONTEXT" \
  -n "$OCE_PLATFORM_NAMESPACE" exec statefulset/postgres -c postgres -- \
  psql -X -v ON_ERROR_STOP=1 -U postgres -d openclaw_enterprise -Atc 'SELECT 1;'
```

Require authenticated Installation access, platform Namespace `default` status `ready`, `/readyz` HTTP 200 and Ready platform Pods. Also require PostgreSQL `1/1` Ready, PVC `postgres-data` `Bound`, `pg_isready` accepting connections and the query returning `1`. PostgreSQL is a StatefulSet, not a Deployment; current first-Agent IAM/Secret checks execute against `statefulset/postgres`. The platform Namespace is distinct from Kubernetes' built-in `default` namespace. Retain its returned `ns_...` ID privately; do not invent IDs.

Open the printed **Browser console** URL. With these examples it is:

```text
https://console.occ-dev-oce-onboarding.oce.localhost:8444/console/
```

Follow [upstream browser trust instructions](https://github.com/openclaw/openclaw-enterprise/blob/8023db20d5a7cfa84dbfe734d43898fc8cc354ce/docs/guides/quickstart.md#open-the-platform-console) for the printed public `browser-ca.crt`, using an organization-approved browser trust method on CSB. Import only that certificate if your method permits it, never private keys or the state directory; remove imported trust when discarding the installation. An approved exact-site development exception is another operator choice after checking the local certificate chain and hostname. The October 7 browser sign-in used that verified local exception; it did not import a CA or change system trust. Do not disable certificate verification globally. If neither method is permitted, record the browser-trust blocker.

For this profile's printed hostname, an explicit-CA check keeps trust scoped to one request and verifies the hostname against the local certificate:

```bash
export OCE_BROWSER_HOST="console.$OCC_DEVELOPMENT_KUBERNETES_CLUSTER.oce.localhost"
curl --fail --max-time 10 --output /dev/null --write-out '%{http_code}\n' \
  --cacert "$OCC_DEVELOPMENT_STATE_DIRECTORY/browser-ca.crt" \
  --resolve "$OCE_BROWSER_HOST:$OCC_DEVELOPMENT_BROWSER_PORT:127.0.0.1" \
  "https://$OCE_BROWSER_HOST:$OCC_DEVELOPMENT_BROWSER_PORT/console/"
```

Require HTTP `200`, then handle any browser-owned trust prompt through the approved local method. This check does not import trust or sign in; verify actual HTTPS password login and access to the intended Namespace in the browser.

Sign in as `admin@development.openclaw.invalid` using the generated **Administrator password file**, ordinarily `initial-admin-password` in private state. Read it locally without logged output. Password login uses HTTPS; port 3300 is the separate service-key API. HTTP password sign-in can correctly fail with origin/CSRF 403; do not weaken that policy.

## 6. Deploy the upstream first Agent

[![Credential flow showing model Secret and IAM separately from administrator and transport authentication](assets/credential-flow.svg)](assets/credential-flow.svg)

The model key, administrator service key, HTTPS console password and native Agent transport credential have distinct purposes. The diagram follows the direct OpenAI starter; optional hosted GLM uses its separately configured Anthropic-compatible provider and model Secret.

Use a valid **direct OpenAI credential** and explicitly select an available, budget-approved model by its plain ID. This is [upstream's documented prompt-only workflow](https://github.com/openclaw/openclaw-enterprise/blob/e5e206c2a9de01601100c06581cc32f73a174456/docs/guides/first-agent.md), not the historical hosted-GLM task used locally. The reviewed helper fixes the provider URL to `https://api.openai.com/v1` and its API to `openai-responses`; it has no gateway URL or reasoning-effort option.

```bash
export OPENCLAW_FIRST_AGENT_MODEL='<approved direct OpenAI model ID>'
node scripts/first-agent.mjs onboarding-agent --prompt 'What is 2 + 2?'
```

Replace the placeholder first. The helper privately prompts if no key is supplied. For automation, use `OPENAI_API_KEY_FILE` pointing to a protected private file, or approved environment injection through `OPENAI_API_KEY`; supplying both fails. Never put a key in the command, Configuration JSON or chat. A stale exported key is used as is. This helper does not turn an arbitrary gateway credential into a direct OpenAI credential.

Inspect only named variables and redacted settings when routing differs from your selection; never dump the entire environment or a credential-bearing client configuration. The coding agent's own provider settings are separate from the deployed OCE Agent's native Configuration. For example, a stale `CLAUDE_CODE_USE_VERTEX` in a Claude Code client can affect that client's routing; it does not configure OCE. Confirm which selected key input is present without printing its value:

```bash
node --input-type=module <<'NODE'
for (const name of ['OPENAI_API_KEY', 'OPENAI_API_KEY_FILE',
  'OPENCLAW_FIRST_AGENT_MODEL', 'CLAUDE_CODE_USE_VERTEX']) {
  console.log(`${name}: ${process.env[name] ? 'set' : 'unset'}`);
}
NODE
```

The helper creates the Secret and embedded Agent, grants Secret access, prepares transport, deploys and verifies a model turn. Keep it running until **`Model response verified:`** and **`Agent response:`** appear; record the returned active revision. Initial startup may take several minutes. Use the HTTPS console origin printed by setup; the helper's API-origin console link does not replace the password-login HTTPS origin. Verify the same Agent and revision in the console. It remains after the helper exits.

Tools/native admin UI are disabled by this starter. A prompt response does not prove filesystem tools. Rerun the same helper-created Agent name for further prompts; use a new name for a console-created Agent. Follow upstream's replacement-key procedure if authentication fails.

### Approved gateway models

An OpenAI-family model behind an AI gateway is a separate provider configuration. The model name does not establish the gateway's API or authentication compatibility. Before sending a key or inference request, establish these approved inputs:

| Input | Check |
| --- | --- |
| Endpoint and protocol | Exact HTTPS base URL and supported native API: `openai-responses`, `openai-completions` (chat completions) or `anthropic-messages`. A gateway can support only a subset. Preserve a required URL prefix. |
| Authentication | The gateway's bearer-key or `x-api-key` contract, represented by a runtime-supported provider/Secret reference. Do not send a gateway key to direct OpenAI or assume the Anthropic provider means the model is Claude. |
| Model identifier | Exact gateway catalog ID, including any slash-separated routing parts; compare the saved native Configuration with the intended provider/model reference. The direct helper rejects such IDs. |
| Reasoning effort | The selected model, gateway and pinned runtime must all support the requested effort and its configuration/wire mapping. Model selection alone does not set maximum effort. Record the supported setting; do not claim an effort that was not configured. |
| Authorization and cost | Protected local key file or approved injection, permitted task data, explicit model/budget and bounded verification calls. Startup itself performs a model probe. |

Create a **separate console/API-managed Agent**, following [native Configuration](https://github.com/openclaw/openclaw-enterprise/blob/e5e206c2a9de01601100c06581cc32f73a174456/docs/reference/configuration.md) and [Secret/IAM deployment](https://github.com/openclaw/openclaw-enterprise/blob/e5e206c2a9de01601100c06581cc32f73a174456/docs/guides/deploy/production-agents.md#grant-the-agent-access-to-its-model-secret). Save the gateway key in a Namespace Secret, use a `harnessAuth` Secret binding and native provider `apiKey` SecretRef, and grant the exact Agent `operate` on that Secret. Keep the URL/model/API configuration non-secret; never inline a key in Advanced settings. Do not mutate the helper-managed Agent, whose saved Configuration is deliberately checked on reuse.

Deploy the saved revision, require its native startup probe to pass, then verify an authenticated model response and matching active revision as in Section 7. Preserve bounded startup checks; a catalog response or successful direct gateway request alone does not qualify OCE routing. A custom endpoint, multi-part model ID, alternate authentication or dedicated Codex adapter needs fresh verification. This public guide supplies no company gateway endpoint or credential.

Keep credential brokering/proxy configuration separate from model routing. Selecting an OpenShell credential gateway or reaching its proxy does not establish that the runtime supports a gateway model, protocol, multi-part ID or reasoning effort. Check the actual saved provider/model reference and deployed image's implementation before inference; avoid patching experimental OpenShell routing as an onboarding shortcut.

### OpenAI-compatible gateway configuration: GPT-6 Luna, maximum effort

This configuration selects provider model ID `gpt-6-luna` through an approved OpenAI-Responses-compatible gateway using bearer API-key authentication. Its OCE/native reference is `openai/gpt-6-luna`; provider ID is `openai`, Harness is `openclaw`, and execution mode is `embedded`. The October 7 Lima/rootful-Podman CSB run verified the exact admitted/frozen Configuration, a matching Ready gateway Pod and succeeded revision, a fresh nonce response and arithmetic result **437**, plus HTTPS sign-in. Full cluster/VM resume preserved the same revision/configuration/image and Ready Pod; resume verification sent no new model-response test prompt. `thinkingDefault=max` and its source-reviewed mapping were preserved; wire-level effort was not independently captured. Tools were denied and not exercised; billed spend was not measured. The earlier Colima/Docker model check remains historical evidence. Use this only when your approved gateway advertises that exact model and supports Responses and `max` effort; a different gateway needs separate qualification.

Set the gateway's exact **HTTPS API base URL**, retaining its required path prefix (commonly ending in `/v1`), rather than its `/responses` request URL. This block writes a non-secret Configuration only; it creates no OCE resource and makes no model call:

```bash
export OCE_GATEWAY_BASE_URL='<approved OpenAI-compatible HTTPS API base URL>'
export OCE_CONFIGURATION_FILE="$OCE_WORK/private/embedded-openai-gateway.json"
node --input-type=module <<'NODE'
import { writeFileSync } from 'node:fs';
const destination = process.env.OCE_CONFIGURATION_FILE;
const url = new URL(process.env.OCE_GATEWAY_BASE_URL);
if (!destination || url.protocol !== 'https:' || url.username || url.password ||
    url.search || url.hash || /\/(?:responses|chat\/completions)\/?$/.test(url.pathname)) {
  throw new Error('Use an approved HTTPS API base URL and a private output path.');
}
const providerModelId = 'gpt-6-luna';
const model = `openai/${providerModelId}`;
const configuration = { kind: 'agent', values: {
  gateway: {
    mode: 'local', bind: 'lan', controlUi: { enabled: false },
    auth: { password: {
      source: 'env', provider: 'default', id: 'OPENCLAW_GATEWAY_PASSWORD',
    } },
    http: { endpoints: { chatCompletions: { enabled: true } } },
  },
  agents: { defaults: {
    model, skipBootstrap: true, thinkingDefault: 'max',
    models: { [model]: { agentRuntime: { id: 'openclaw' } } },
  } },
  tools: { deny: ['*'] },
  secrets: { providers: { model: {
    source: 'env', allowlist: ['OPENAI_API_KEY'],
  } } },
  models: { providers: { openai: {
    baseUrl: url.toString().replace(/\/$/, ''), api: 'openai-responses',
    apiKey: { source: 'env', provider: 'model', id: 'OPENAI_API_KEY' },
    models: [{ id: providerModelId, name: 'GPT-6 Luna', input: ['text'],
      reasoning: true, thinkingLevelMap: { max: 'max' },
      compat: {
        supportsReasoningEffort: true,
        supportedReasoningEfforts: ['none', 'low', 'medium', 'high', 'xhigh', 'max'],
        supportsTemperature: false,
      },
      contextWindow: 1050000, maxTokens: 2048 }],
  } } },
} };
writeFileSync(destination, JSON.stringify(configuration, null, 2) + '\n', {
  mode: 0o600, flag: 'wx',
});
console.log('Non-secret gateway configuration written; no resources or inference created.');
NODE
```

The explicit `thinkingDefault`, `thinkingLevelMap` and compatibility metadata map maximum thinking to Responses reasoning effort in the reviewed native runtime. Preserve this mapping in the saved and frozen revision. Confirm the gateway's current model limits before changing the declared metadata. Do not add a second `Authorization`/`x-api-key` header to this provider: its `apiKey` SecretRef supplies the bearer credential through the native SDK. This recipe does not describe an Anthropic-Messages gateway.

The fresh verification used an explicitly authorized bounded inference budget. That authorization is not metered billing evidence or a hard spending cap enforced by this recipe. Record your own approved budget and provider usage without publishing account details.

Complete the existing [console creation workflow](https://github.com/openclaw/openclaw-enterprise/blob/8023db20d5a7cfa84dbfe734d43898fc8cc354ce/docs/reference/console/create-and-deploy.md#create-an-agent):

1. In the Ready `default` platform Namespace, choose **Create Agent → Start without Preset → OpenAI → OpenClaw → Embedded**. Use a unique owned Agent name and **Enter model ID manually** with `gpt-6-luna`.
2. Choose an existing approved model Secret or create one from the protected **key-only** input through the approved credential workflow. A raw key file contains one token, with no Markdown backticks, prose or shell assignment. Keep it out of chat, logs and Advanced settings. API automation can read `<approved protected key file>` directly in process memory through the [documented Secret creation flow](https://github.com/openclaw/openclaw-enterprise/blob/8023db20d5a7cfa84dbfe734d43898fc8cc354ce/docs/reference/drivers/kubernetes-secret.md#create-a-namespace-owned-secret).
3. In **Advanced settings**, use the generated native **`values` object**; `kind` is OCC resource metadata. Confirm the model remains `openai/gpt-6-luna`, provider base URL/API and maximum-effort mapping are preserved, tools are denied, and the model key remains a Secret reference.
4. Save the Agent with `harnessAuth.method=api_key` and the exact Namespace-owned model Secret. The caller and Agent service principal both require **`operate` on that exact Secret**. Confirm credential access completed; if the console reports a grant failure, use **Retry credential access** or the [documented exact IAM grant](https://github.com/openclaw/openclaw-enterprise/blob/e5e206c2a9de01601100c06581cc32f73a174456/docs/guides/deploy/production-agents.md#grant-the-agent-access-to-its-model-secret). Kubernetes RBAC does not replace that grant.
5. Choose **Deploy new version**; it prepares initial transport credentials and admits the saved Configuration. Require the exact deployment to succeed and the same revision to become active. Then perform Section 7's authenticated nonce/prompt check against that revision, recording model, protocol and the frozen maximum-effort configuration. This starter denies tools; a prompt response does not prove tool execution.

For CLI/API automation, reuse the upstream [Agent preparation, IAM and transport/deployment procedure](https://github.com/openclaw/openclaw-enterprise/blob/e5e206c2a9de01601100c06581cc32f73a174456/docs/guides/deploy/production-agents.md#prepare-each-agent), with this generated Configuration, `AGENT_EXECUTION_MODE=embedded`, `HARNESS_AUTH_METHOD=api_key` and server-returned IDs from your local Ready Namespace. The complete sequence is **Secret → Configuration → Agent → exact IAM grant → runtime credentials → deployment → exact revision/model verification**. The [CLI](https://github.com/openclaw/openclaw-enterprise/blob/8023db20d5a7cfa84dbfe734d43898fc8cc354ce/docs/reference/cli.md) supports Configuration/Agent creation, IAM role/access binding, runtime-credential provisioning and exact `deployment-status`; Secret creation accepts a protected JSON input or the linked protected-file API flow. The source's `occ` examples mean `./bin/occ` in this checkout. The local launcher has already prepared its tenant RBAC and routing: do not apply production RoleBindings or reinstall the platform.

Inspect IDs/recorded outcomes before retrying a lost create/deploy response. Keep original credentials and operator receipts private. This Configuration block is not a replacement installer or a public gateway-specific helper; the linked resource procedures complete deployment. Preserve upstream startup probe limits and an explicit inference budget.

### Optional hosted GLM example

The historically successful embedded model was **GLM 5.3**, `rits/zai-org/glm-5-3`, via an operator-approved Anthropic-Messages-compatible endpoint at source `affac2bfc1370e590e6da570bcaaad4a207c9f09`. Native model reference: `anthropic/rits/zai-org/glm-5-3`. “Anthropic” names the protocol, not a Claude model. The following configuration records that historical path; it is not current acceptance for a new gateway/runtime. This example requires an independently available authorized endpoint and its own credential; this public repository supplies neither. Refresh provider availability, capabilities and price before inference.

Set `OCE_MODEL_BASE_URL` to that approved **HTTPS origin**, with no credentials or `/v1/messages` suffix. The following writes non-secret configuration only:

```bash
export OCE_MODEL_BASE_URL='<approved compatible HTTPS origin>'
export OCE_CONFIGURATION_FILE="$OCE_WORK/private/embedded-glm.json"
node --input-type=module <<'NODE'
import { writeFileSync } from 'node:fs';
const destination = process.env.OCE_CONFIGURATION_FILE;
const url = new URL(process.env.OCE_MODEL_BASE_URL);
if (!destination || url.protocol !== 'https:' || url.username || url.password ||
    url.search || url.hash || !['', '/'].includes(url.pathname)) {
  throw new Error('Use a private file path and approved HTTPS origin.');
}
const model = 'anthropic/rits/zai-org/glm-5-3';
const configuration = { kind: 'agent', values: {
  gateway: {
    mode: 'local', bind: 'lan', controlUi: { enabled: false },
    auth: { password: {
      source: 'env', provider: 'default', id: 'OPENCLAW_GATEWAY_PASSWORD',
    } },
    http: { endpoints: { chatCompletions: { enabled: true } } },
  },
  agents: { defaults: {
    model, skipBootstrap: true, thinkingDefault: 'off',
    models: { [model]: { agentRuntime: { id: 'openclaw' } } },
  } },
  tools: { allow: ['read', 'write'] },
  secrets: { providers: { model: {
    source: 'env', allowlist: ['ANTHROPIC_API_KEY'],
  } } },
  models: { providers: { anthropic: {
    baseUrl: url.origin, api: 'anthropic-messages',
    apiKey: { source: 'env', provider: 'model', id: 'ANTHROPIC_API_KEY' },
    models: [{ id: model, name: 'Hosted GLM', input: ['text'],
      reasoning: true, contextWindow: 128000, maxTokens: 1024 }],
  } } },
} };
writeFileSync(destination, JSON.stringify(configuration, null, 2) + '\n', {
  mode: 0o600, flag: 'wx',
});
console.log('Non-secret configuration written; no inference performed.');
NODE
```

At the historical pin, this path required the full provider-prefixed nested model reference to avoid truncation of a slash-containing ID, plus `reasoning:true` and `thinkingDefault:"off"` to send explicit thinking-disabled. Recheck current native runtime semantics before adapting it. Preserve the upstream [bounded model startup probe](https://github.com/openclaw/openclaw-enterprise/blob/e5e206c2a9de01601100c06581cc32f73a174456/docs/reference/harness-execution.md); do not enlarge or bypass it to hide an authentication/configuration failure.

In a Ready Namespace choose **Create Agent → Start without Preset → Anthropic → OpenClaw → Embedded**. Store the model credential in a Namespace Secret, select it as `harnessAuth`, enter the model ID and use the generated native **`values` object** under Advanced settings. `kind` is OCC resource metadata, not native configuration. Follow [upstream console creation](https://github.com/openclaw/openclaw-enterprise/blob/affac2bfc1370e590e6da570bcaaad4a207c9f09/docs/reference/console/create-and-deploy.md), review the saved Secret/configuration and choose **Deploy new version**.

For API automation, use the real resource sequence: Secret → Configuration → Agent → exact Secret IAM grant → runtime credentials → deployment. Both caller and consuming Agent need `operate` on that Secret. Follow [Secret input](https://github.com/openclaw/openclaw-enterprise/blob/affac2bfc1370e590e6da570bcaaad4a207c9f09/docs/reference/drivers/kubernetes-secret.md#create-a-namespace-owned-secret) and [exact IAM/deployment contracts](https://github.com/openclaw/openclaw-enterprise/blob/affac2bfc1370e590e6da570bcaaad4a207c9f09/docs/guides/deploy/production-agents.md#grant-the-agent-access-to-its-model-secret). Use server-returned IDs; inspect unknown request outcomes before retrying creates. Kubernetes RBAC is separate from OCC IAM.

### Dedicated Codex is a separate integration

Codex is an execution engine, not a model choice. Current upstream documents an experimental OpenShell `--harness codex` first-Agent path with direct OpenAI credentials; it is separate from this `Sandbox Driver=none` embedded starter and does not establish production qualification. Custom provider adapters are outside this public starter; none is shipped here. Do not inject a gateway key into the stock direct-provider path and assume compatibility. Qualify provider routing, discovery, credentials, native sandbox and genuine tasks separately before publishing a dedicated recipe.

## 7. Verify and record the result

For the direct prompt-only route, require the helper's verified response, active revision and same console Agent. For a separate gateway-managed Agent, send a fresh nonce through its matching gateway's authenticated native endpoint, require the returned nonce and actual prompt answer, and match the deployed revision/model/protocol. Record the configured reasoning effort if selected. Report **“prompt response passed; filesystem tools not exercised.”** when tools were not tested.

For an optional tool-enabled Agent, check the exact admitted revision, successful deployment and active revision identity. Use the explicit kubeconfig/context; discover its backing namespace through `openclaw.dev/namespace=<returned Namespace ID>` and gateway Pod through `openclaw.dev/agent=<returned Agent ID>` plus `openclaw.dev/workload-role=gateway`. Match the revision/configuration and actual image digest; overlapping old/new Pods require more than name similarity.

Run the smoke task through the matching gateway's authenticated native endpoint. The optional configuration exposes `/v1/chat/completions` at `http://127.0.0.1:8080` **inside the gateway container**. Read `OPENCLAW_GATEWAY_PASSWORD` privately in process memory; send it as bearer authentication without command-argument/log exposure. Require unauthenticated access to return 401/403. Bound each request; the historical model call used a 160-second timeout.

Generate a fresh nonce such as `OCE_SMOKE_` plus a UUID. Ask the Agent to write `/home/node/workspace/oce-smoke-<nonce>.txt` containing exactly that nonce without newline, read it back and calculate **19 × 23**, with **437** on the final line. The verifier must never create or repair that file.

Require these checks:

1. Exact deployment succeeded; intended Pod Ready; actual image digest recorded.
2. Unauthenticated transport denied; authenticated task HTTP 200.
3. Direct workspace readback matches the nonce byte-for-byte.
4. Native `write`/`read` calls and matching successful result IDs refer to the exact path and nonce.
5. Final arithmetic answer is 437; exact model/protocol recorded.

The historical runtime used SQLite-backed history; recover the original task through the selected runtime's authenticated native `sessions.list` / `chat.history`, rather than guessing a storage path. Check the current runtime's history contract after an update. Recovery must not make another inference call or write the expected file. A model's claim alone is insufficient. See [upstream model verification](https://github.com/openclaw/openclaw-enterprise/blob/8023db20d5a7cfa84dbfe734d43898fc8cc354ce/docs/guides/operate/model-verification.md).

Keep a private non-secret receipt with source/tool/kernel versions, actual image digests, selected model/protocol, timestamp, exact revision checks and gaps. Keep internal IDs/endpoints out of public reports. Historical GLM acceptance establishes this small execution workflow, not broad quality or production qualification.

## 8. Pause, resume or discard

Retain the selected engine/connection, Lima instance or VM profile, cluster and state exports. In a new shell, reestablish them before lifecycle commands. Direct `k3d` commands need the host Docker API socket even when the engine is Podman; `CONTAINER_CONNECTION` alone does not select that socket for k3d. Restore only the matching installation's recorded endpoint, without printing its private state:

```bash
: "${OCC_DEVELOPMENT_STATE_DIRECTORY:?Restore the owned installation state path}"
: "${OCC_DEVELOPMENT_KUBERNETES_CLUSTER:?Restore the owned cluster name}"
: "${OCC_DEVELOPMENT_CONTAINER_ENGINE:?Restore the selected engine}"
unset DOCKER_CONTEXT DOCKER_TLS_VERIFY DOCKER_CERT_PATH
DOCKER_HOST="$(node --input-type=module <<'NODE'
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
try {
  const state = JSON.parse(readFileSync(join(process.env.OCC_DEVELOPMENT_STATE_DIRECTORY, 'state.json'), 'utf8'));
  if (state.cluster !== process.env.OCC_DEVELOPMENT_KUBERNETES_CLUSTER ||
      state.containerEngine !== process.env.OCC_DEVELOPMENT_CONTAINER_ENGINE ||
      typeof state.dockerHost !== 'string' || !state.dockerHost.startsWith('unix:///') ||
      /[\r\n]/.test(state.dockerHost)) throw new Error();
  process.stdout.write(state.dockerHost);
} catch {
  console.error('Cannot restore the matching local engine endpoint.');
  process.exit(1);
}
NODE
)" || exit 1
export DOCKER_HOST
```

Stop OCE's owned cluster first. Stop the VM only when it belongs solely to this installation; keep a reused/shared VM running for unrelated workloads.

```bash
# Retain cluster storage; release its active workloads.
k3d cluster stop "$OCC_DEVELOPMENT_KUBERNETES_CLUSTER"
```

For the recommended owned Lima instance, once its OCE cluster is stopped and it hosts no unrelated workloads:

```bash
: "${OCE_LIMA_INSTANCE:?Restore the owned Lima instance name}"
limactl stop "$OCE_LIMA_INSTANCE"
```

Resume that instance before restoring the endpoint with the block above:

```bash
: "${OCE_LIMA_INSTANCE:?Restore the owned Lima instance name}"
limactl start --tty=false "$OCE_LIMA_INSTANCE"
unset CONTAINER_CONNECTION
export CONTAINER_HOST="$(limactl list "$OCE_LIMA_INSTANCE" \
  --format 'unix://{{.Dir}}/sock/podman.sock')"
```

Then restore `DOCKER_HOST` with the matching-state block and run `k3d cluster start "$OCC_DEVELOPMENT_KUBERNETES_CLUSTER"`.

Only for the historical dedicated Colima profile explicitly chosen in Section 3, when it hosts no unrelated workloads:

```bash
colima --profile "$OCE_PROFILE" stop
```

For that dedicated Colima profile, restore the endpoint with the block above, then resume:

```bash
colima --profile "$OCE_PROFILE" start --activate=false --ssh-config=false
k3d cluster start "$OCC_DEVELOPMENT_KUBERNETES_CLUSTER"
```

For a reused runtime, make the selected approved engine available through its recorded connection, restore the endpoint with the block above and start only the owned cluster with `k3d cluster start "$OCC_DEVELOPMENT_KUBERNETES_CLUSTER"`. Repeat PostgreSQL/PVC/database readiness and exact active-Agent checks. **`occ dev up` creates/recreates; it is not resume.** PostgreSQL and Agent files persist on the k3d node's storage; stop/start keeps it, whereas deleting the cluster or backing engine/VM storage destroys it.

The October 7 Lima receipt exercised the complete cluster stop → VM stop/start → cluster start sequence. PostgreSQL StatefulSet/PVC/query, API/default Namespace readiness, the same Agent revision/configuration/image/Ready Pod, verified TLS and the browser session/Agent deployment display persisted. Resume verification sent no new test prompt; it establishes retained state and readiness, not a new model response. The smoke Agent was stopped after verification, retaining the platform/console and saved Configuration.

Only to intentionally discard this owned installation, from its matching checkout/environment:

```bash
./bin/occ dev down
```

This deletes cluster, database, credentials, Agent state/workspaces and audit history. Stop/start retains storage; deletion does not. Remove any imported development CA trust. Stop unwanted Agents through their authorized lifecycle API; saving configuration does not update a running revision. Do not delete PVCs to repair normal scheduling or displayed sparse capacity.

## 9. Diagnose bounded failures

| Failure | Check and repair |
| --- | --- |
| Registry unauthorized | Use the source-build baseline; never dump registry auth. |
| Build memory admission | Size the dedicated VM; preserve the upstream heap guard. |
| Podman cannot find a context-mounted build helper | Check the Fedora/Podman context-file compatibility finding below; record the source repair instead of assuming plain `main` passed. |
| Podman image import cannot reach `/var/run/docker.sock` | See the tagged-image import diagnostic below. The image build can succeed while k3d's tools-container import fails. |
| `RUN --mount` needs BuildKit | Require `docker buildx version`; install/register the approved CLI plugin before retrying. |
| Unsupported `image save --platform` | Select a compatible Docker CLI; preserve unrelated daemons. |
| Engine daemon cannot pull images | Check the selected guest's DNS and `/etc/resolv.conf` before diagnosing k3d. The historical Colima dangling-resolver repair applies only to that exact cause. |
| cert-manager/Pod image pull DNS failure | Inspect node resolver and exact Pod events; engine/VM pulls alone do not prove node DNS. Use an approved reachable node resolver only when needed. |
| HTTP password login 403 | Use the printed HTTPS browser origin; preserve CSRF policy. |
| First-Agent reports `kubectl` failure | Check the selected state/context, PostgreSQL StatefulSet, database PVC and query before investigating Agent/model configuration. |
| Namespace not Ready | Inspect exact provisioning, worker and platform/RBAC state before creating Agents. |
| Provider startup failure | Verify authorized endpoint/model, private credential, Secret grants and exact configuration; preserve startup checks. |
| History collector failure | Recover original native task read-only; never synthesize tool evidence. |
| Endpoint protection terminates a workload | Retain a private non-secret incident summary and use the organization's approved resolution or alternative environment. |

### Podman build helper mount failure

The first fresh Lima/Fedora 44 build at `e5e206c2a9de01601100c06581cc32f73a174456` failed with **`Cannot find module /tmp/with-pinned-matrix-sdk-crypto.mjs`**. The official launcher rolled back the owned cluster cleanly. The helper was tracked and not excluded by `.dockerignore`; both dependency stages in `deploy/runtime/Dockerfile` mounted it as a single build-context file.

A bounded reproduction with Podman `5.8.7` / Buildah `1.43.4` found the single context-file mount unreadable with permission denied at both mode `0600` and `0644`. A cross-stage directory mount and `COPY` preserved readable exact file bytes. SELinux remained Enforcing. These observations establish the build compatibility failure, not an exact SELinux root cause; changing host/guest security or merely changing the file's mode is not the verified repair.

The source repair in [PR #1543](https://github.com/openclaw/openclaw-enterprise/pull/1543), initial commit `d4173134f27d0961126b2df0f804ae90d1f3d7c0` based on `e5e206c2a9de01601100c06581cc32f73a174456`, packages the helper with `COPY` in the shared intermediate stage and removes the two single context-file bind mounts. It retains the pinned SDK library/checksum path, existing cross-stage library mount and private build-secret mounts. That build completed both dependency installations and runtime image creation, then hit the separate image-import failure below. With both repairs frozen at `a6bfbc985943bd79f49def459fdac13f18e06861`, official platform/browser/model acceptance and full VM/cluster resume passed. The recorded unmodified baseline did not pass this reproduction. These commits identify evidence, not an instruction to check out an older baseline.

### Podman tagged-image import failure

The next official launch completed the runtime image build, then k3d's default tagged-image import failed because its tools container could not reach a daemon at **`/var/run/docker.sock`**. The launcher rolled back the owned cluster cleanly. Successful `podman info` through the selected host socket does not establish that socket's availability inside k3d's tools container.

A targeted launcher repair is published in [PR #1543](https://github.com/openclaw/openclaw-enterprise/pull/1543), revision `a6bfbc985943bd79f49def459fdac13f18e06861`: after resolving the engine-recorded image name, Podman uses the existing archive/direct-import branch. It retains image/digest verification and archive cleanup; Docker's tagged-image path stays unchanged. The official repaired launch imported runtime/controller/PostgreSQL images and passed networking, native Codex, platform/browser/model and resume checks. Do not guess a `DOCKER_SOCK` override or bypass the official checks. The repaired Go launcher must be rebuilt with `pnpm cli:build` before retrying.

### Temporary repair from current main

Start with Section 2's clean current-`main` checkout, declared toolchain and completed frozen dependency install. Read upstream `AGENTS.md`. Capture the public repair diff once in a new private file; this downloads data and executes no downloaded script:

```bash
set -euo pipefail
cd "$OCE_WORK/openclaw-enterprise"
OCE_SOURCE_STATUS="$(git status --porcelain)" || exit 1
test -z "$OCE_SOURCE_STATUS" || {
  printf '%s\n' 'Use a clean current-main checkout before the repair.' >&2
  exit 1
}
OCE_BASE_SHA="$(git rev-parse HEAD)"
OCE_REPAIR_PR='https://github.com/openclaw/openclaw-enterprise/pull/1543'
umask 077
mkdir -p "$OCE_WORK/private"
chmod 700 "$OCE_WORK/private"
OCE_REPAIR_PATCH="$(mktemp "$OCE_WORK/private/podman-setup-repair.XXXXXX")"
curl --fail --silent --show-error --location --max-time 60 \
  --proto '=https' --proto-redir '=https' \
  "${OCE_REPAIR_PR}.diff" --output "$OCE_REPAIR_PATCH"
chmod 600 "$OCE_REPAIR_PATCH"
python3 - "$OCE_REPAIR_PATCH" <<'PY'
from pathlib import Path
import sys
lines = Path(sys.argv[1]).read_text().splitlines()
for path in ['deploy/runtime/Dockerfile', 'internal/occdev/kubernetes.go']:
    if f'diff --git a/{path} b/{path}' not in lines:
        raise SystemExit(f'The captured repair has no {path} diff; stop and review.')
PY
git apply --stat --include=deploy/runtime/Dockerfile \
  --include=internal/occdev/kubernetes.go "$OCE_REPAIR_PATCH"
```

**Read the captured diff and both current source files before continuing.** In the Dockerfile, verify one helper `COPY` in the shared dependency-input stage and removal of exactly two context-file helper binds. In `internal/occdev/kubernetes.go`, verify that the archive branch after recorded-name selection changes from `if staged` to `if staged || r.engine == "podman"`, with its explanatory comment. Require no other behavior changes in either file. Review the accompanying regression tests and documentation; the next block applies only the two product files. If the PR has changed beyond this contract, review the new proposal rather than applying it blindly.

In the same shell, check **both files before applying either**. Each may already contain its fix, allowing current `main` to include one or both repairs:

```bash
set -euo pipefail
cd "$OCE_WORK/openclaw-enterprise"
test "$(git rev-parse HEAD)" = "$OCE_BASE_SHA" || exit 1
OCE_SOURCE_STATUS="$(git status --porcelain)" || exit 1
test -z "$OCE_SOURCE_STATUS" || exit 1
OCE_REPAIR_APPLY_COMMAND=(git apply)
OCE_REPAIR_NEEDED=no
for OCE_REPAIR_PATH in deploy/runtime/Dockerfile internal/occdev/kubernetes.go; do
  if git apply --check --include="$OCE_REPAIR_PATH" "$OCE_REPAIR_PATCH" 2>/dev/null; then
    OCE_REPAIR_APPLY_COMMAND+=("--include=$OCE_REPAIR_PATH")
    OCE_REPAIR_NEEDED=yes
    printf '%s\n' "plan:$OCE_REPAIR_PATH=apply-local-repair"
  elif git apply --check --reverse --include="$OCE_REPAIR_PATH" "$OCE_REPAIR_PATCH" 2>/dev/null; then
    printf '%s\n' "plan:$OCE_REPAIR_PATH=already-applied-in-baseline"
  else
    printf '%s\n' "Source differs: $OCE_REPAIR_PATH. Stop and inspect upstream; do not force this patch." >&2
    exit 1
  fi
done
if test "$OCE_REPAIR_NEEDED" = yes; then
  "${OCE_REPAIR_APPLY_COMMAND[@]}" "$OCE_REPAIR_PATCH" || exit 1
  OCE_REPAIR_STATUS='applied-local-repair'
else
  OCE_REPAIR_STATUS='already-applied-in-baseline'
fi
git diff -- deploy/runtime/Dockerfile internal/occdev/kubernetes.go
printf '%s\n' "base=$OCE_BASE_SHA" "repair_pr=$OCE_REPAIR_PR" "status=$OCE_REPAIR_STATUS"
shasum -a 256 "$OCE_REPAIR_PATCH" deploy/runtime/Dockerfile internal/occdev/kubernetes.go
# Use Section 2's declared toolchain and installed frozen dependencies.
pnpm cli:build
```

Record those outputs privately, plus the reviewed PR revision and final runtime image digest. Label any applied result **current main plus recorded local repair**, rather than plain-main acceptance. Per-file reverse checks handle already-merged or partially merged fixes; an equivalent newer implementation may fail both checks and needs inspection, not forced application. Freeze this checkout for the installation. Complete Section 2's frozen dependency install and CLI build if not done yet; rebuild after every Go repair. Wait for any failed launch's rollback to finish, then rerun the official launcher with all networking, sandbox, database, browser and model acceptance checks. Do not check out the historical proof commit to avoid reviewing current source.

### Docker Buildx discovery

This subsection applies to the Docker path; it does not make Buildx a Podman prerequisite. OCE's runtime Dockerfile uses BuildKit `RUN --mount=type=secret`. If `docker buildx version` is unavailable, the CLI can fall back to the legacy builder even when a standalone `docker-buildx` executable exists. Install the approved Buildx package, then verify it as a **Docker subcommand** with the same `DOCKER_CONFIG` as startup.

If Homebrew supplied the binary but the Docker plugin directory does not contain it, this registers that existing binary without overwriting a plugin:

```bash
export OCE_DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}"
test -x "$(brew --prefix)/bin/docker-buildx"
mkdir -p "$OCE_DOCKER_CONFIG/cli-plugins"
ln -s "$(brew --prefix)/bin/docker-buildx" \
  "$OCE_DOCKER_CONFIG/cli-plugins/docker-buildx"
docker buildx version
```

Run this only after establishing that the plugin path is absent; if `ln` reports an existing path, inspect it instead of deleting or replacing it. A non-Homebrew installation should use its approved packaging/plugin setup. Wait for a failed startup and its owned-resource rollback to finish before retrying.

### Guest and engine-daemon DNS

For the recommended Lima guest, inspect its actual resolver without changing host VPN/DNS:

```bash
limactl shell "$OCE_LIMA_INSTANCE" cat /etc/resolv.conf
limactl shell "$OCE_LIMA_INSTANCE" getent hosts registry-1.docker.io
```

A successful guest lookup does not establish node DNS. The tested Lima guest kept SELinux Enforcing and native user namespaces working without sysctl relaxation. Its official startup/network/native Codex checks passed without a DNS override; scoped owned-node seccomp preparation ran normally. The following historical repair applies only to its established Colima/Ubuntu cause; do not apply it to a working Fedora guest.

First distinguish **guest/daemon DNS** from **k3d node DNS**. Inspect the selected Linux guest using its VM manager. The following commands apply only to the explicitly chosen owned Colima example:

```bash
colima --profile "$OCE_PROFILE" ssh -- readlink /etc/resolv.conf || true
colima --profile "$OCE_PROFILE" ssh -- cat /etc/resolv.conf || true
colima --profile "$OCE_PROFILE" ssh -- systemctl status systemd-resolved.service || true
colima --profile "$OCE_PROFILE" ssh -- getent hosts registry-1.docker.io || true
```

A source download that works on macOS does not prove the Linux guest can resolve image registries. One fresh Colima guest had `/etc/resolv.conf` pointing to an absent systemd stub and no `systemd-resolved.service`. Diagnose those exact conditions before repairing it; do not replace a working resolver or an existing/shared VM's network configuration.

For that **dedicated owned VM only**, obtain its current DHCP/Lima-advertised IPv4 resolver and confirm it is organization-approved. Keep the original symlink and verify that no prior backup exists. The following rejects non-IPv4/loopback/link-local/multicast/unspecified addresses and changes only the established dangling-symlink case:

```bash
export OCE_GUEST_DNS='<current approved DHCP/Lima IPv4 resolver>'
python3 - <<'PY'
import ipaddress, os
address = ipaddress.ip_address(os.environ['OCE_GUEST_DNS'])
if (address.version != 4 or address.is_loopback or address.is_link_local
    or address.is_multicast or address.is_unspecified
    or str(address) == '255.255.255.255'):
    raise SystemExit('Use the current approved reachable guest IPv4 resolver.')
PY
colima --profile "$OCE_PROFILE" ssh -- sudo sh -c \
  'test -L /etc/resolv.conf && test ! -e /etc/resolv.conf && test ! -e /etc/resolv.conf.oce-original && test ! -L /etc/resolv.conf.oce-original && mv /etc/resolv.conf /etc/resolv.conf.oce-original && printf "nameserver %s\n" "$1" > /etc/resolv.conf' \
  sh "$OCE_GUEST_DNS"
colima --profile "$OCE_PROFILE" ssh -- getent hosts registry-1.docker.io
```

Replace the placeholder first. Record the original symlink, exact resolver source and repair privately. The original target/service absence must be established before this block; an empty placeholder or copied address is not a resolution. Then repeat the owned image pull or launcher, and independently check node DNS below. Verify guest resolution again after VM restart.

If discarding this installation and restoring its original guest state, use the recorded backup only when it is still the original symlink:

```bash
colima --profile "$OCE_PROFILE" ssh -- sudo sh -c \
  'test -L /etc/resolv.conf.oce-original && test -f /etc/resolv.conf && test ! -L /etc/resolv.conf && rm /etc/resolv.conf && mv /etc/resolv.conf.oce-original /etc/resolv.conf'
```

Restoring the broken original makes DNS fail again; repair the guest through its approved VM/image maintenance process before reusing it. Do not alter macOS VPN/DNS or substitute an external public resolver as a convenience.

### k3d node DNS

While the failed rollout is still running, use the known state path/context in a second shell. Keep diagnostic output private; targeted Pod descriptions can include local infrastructure details.

```bash
kubectl --kubeconfig "$OCE_KUBECONFIG" --context "$OCE_CONTEXT" \
  -n cert-manager get pods
kubectl --kubeconfig "$OCE_KUBECONFIG" --context "$OCE_CONTEXT" \
  -n cert-manager describe pods
case "$OCC_DEVELOPMENT_CONTAINER_ENGINE" in docker|podman) ;; *) exit 1 ;; esac
"$OCC_DEVELOPMENT_CONTAINER_ENGINE" exec \
  "k3d-$OCC_DEVELOPMENT_KUBERNETES_CLUSTER-server-0" cat /etc/resolv.conf
"$OCC_DEVELOPMENT_CONTAINER_ENGINE" exec \
  "k3d-$OCC_DEVELOPMENT_KUBERNETES_CLUSTER-server-0" nslookup registry-1.docker.io
```

Set `OCE_KUBECONFIG="$OCC_DEVELOPMENT_STATE_DIRECTORY/kubeconfig"` and `OCE_CONTEXT="k3d-$OCC_DEVELOPMENT_KUBERNETES_CLUSTER"` in that shell even if startup has not yet printed success. Restore its exact engine endpoint/connection before the selected engine's `exec` command. A successful VM/engine image pull can coexist with a failing k3d node resolver.

At the reviewed source, automatic upstream resolver selection applies to **a Linux launcher host with Docker**. A macOS launcher controlling Lima/Podman or Colima/Docker does not meet that condition. If the node cannot resolve registries, establish an organization-approved non-loopback IPv4 DNS server reachable from that node, and use it for the next fresh startup:

```bash
export OCC_DEVELOPMENT_K3D_DNS_RESOLVER='<approved reachable IPv4 DNS server>'
./bin/occ dev up
```

Replace the placeholder first. The setting mounts the owned node's resolver file and disables k3d's conflicting rewrite; it leaves host/VM DNS unchanged. `OCC_DEVELOPMENT_K3D_DNS_RESOLVER=k3d` deliberately retains k3d's default. Do not hardcode a public resolver from another operator's notes or change company VPN/DNS. Wait until the failed run exits, follow its printed cleanup for retained state, then retry; do not launch two owners for one cluster.

### PostgreSQL and first-Agent errors

Current upstream already prints a bounded **`first-agent: <message>`** and exits nonzero; its subprocess errors intentionally do not dump raw stderr. Do not patch it to emit command input, Pod environments, credential files or full SQL. Check the selected resources directly using Section 5's StatefulSet/PVC/`pg_isready`/`SELECT 1` commands. Calls and waits are bounded; a timeout or an active revision without the verified model response is failure, not acceptance.

If `statefulset/postgres` is missing, confirm the selected kubeconfig/context and platform namespace against recorded local setup, check that control plane is `kubernetes`, and inspect whether startup rolled back. The hybrid Compose control plane keeps its database in Compose; these StatefulSet commands do not apply to that profile. A stale checkout that expected a PostgreSQL Deployment should be updated before a new installation, with a new SHA recorded.

If the StatefulSet exists but rollout fails, inspect its Pod and storage events before touching data:

```bash
kubectl --kubeconfig "$OCE_KUBECONFIG" --context "$OCE_CONTEXT" \
  -n "$OCE_PLATFORM_NAMESPACE" get pods -l app=postgres
kubectl --kubeconfig "$OCE_KUBECONFIG" --context "$OCE_CONTEXT" \
  -n "$OCE_PLATFORM_NAMESPACE" describe pvc postgres-data
kubectl --kubeconfig "$OCE_KUBECONFIG" --context "$OCE_CONTEXT" \
  -n "$OCE_PLATFORM_NAMESPACE" get events --field-selector type=Warning
```

Check storage capacity, image availability, scheduling and database readiness. Never create a replacement database by hand, delete a PVC or run `dev down` to cure an unexplained database/Agent error. Restarting is different from recreating; preserve evidence and data until an intentional discard is authorized.

### Conditional guest user-namespace prerequisite

The earlier Colima/Ubuntu guest had `kernel.apparmor_restrict_unprivileged_userns=1`, blocking bubblewrap namespace creation even after reviewed seccomp preparation. Diagnose the selected Linux guest first. For Lima, inspect with `limactl shell "$OCE_LIMA_INSTANCE" uname -a`; this Fedora reproduction passed native user namespaces and the official scoped node seccomp/Codex check without guest sysctl or SELinux relaxation. Do not apply an Ubuntu/AppArmor sysctl merely because another VM needed it. The following commands apply to the historical owned Colima example:

```bash
colima --profile "$OCE_PROFILE" ssh -- uname -a
colima --profile "$OCE_PROFILE" ssh -- sysctl \
  kernel.unprivileged_userns_clone kernel.apparmor_restrict_unprivileged_userns
```

Only if that same cause is established and company policy permits this guest prerequisite, record the original value/file and apply it **inside your dedicated disposable VM**. For an existing/shared VM, obtain its operator's approved compatible environment instead of changing policy for other workloads:

```bash
colima --profile "$OCE_PROFILE" ssh -- sudo sh -c \
  'test ! -e /etc/sysctl.d/70-oce-local-userns.conf && test ! -L /etc/sysctl.d/70-oce-local-userns.conf && umask 077 && printf "%s\n" "kernel.apparmor_restrict_unprivileged_userns=0" > /etc/sysctl.d/70-oce-local-userns.conf && sysctl -w kernel.apparmor_restrict_unprivileged_userns=0'
```

This changes that VM's AppArmor restriction; it is not a shared-cluster workaround or Mac host setting. Rerun official startup with its native checks retained and require workspace-write, outside-write-denied, effective-profile and missing-profile-fails-closed acceptance. Do not use `Unconfined`, disable native sandboxing or bypass checks. See [upstream sandbox preparation](https://github.com/openclaw/openclaw-enterprise/blob/8023db20d5a7cfa84dbfe734d43898fc8cc354ce/docs/guides/deploy/codex-sandbox.md).

To restore the observed original value of **1**, pause the owned cluster while the VM remains running, then:

```bash
colima --profile "$OCE_PROFILE" ssh -- sudo sh -c \
  'rm -f /etc/sysctl.d/70-oce-local-userns.conf; sysctl -w kernel.apparmor_restrict_unprivileged_userns=1'
```

The creation block intentionally refuses a preexisting file or symlink. If your baseline differs or an approved prior configuration exists, preserve it and restore the actual original value/file instead of using the example value. Future Codex runs require compatible host prerequisites. Shared/production node changes belong to the cluster operator's reviewed provisioning process.

## Completion boundary

Report the checks actually passed: **platform ready**, **prompt response verified**, or **native tool task verified**. Keep failures and unexercised paths explicit. This starter does not qualify full OpenShell integration, repository/messaging integrations, production OpenShift or other host architectures. Keep this detailed runbook and the concise human guide synchronized when changing any contract.
