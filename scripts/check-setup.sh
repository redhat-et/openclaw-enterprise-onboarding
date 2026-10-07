#!/usr/bin/env bash
# Read-only preflight: no installs, downloads, VM changes or credential values.
set -uo pipefail
failures=0
source_path=''
docker_host=''
podman_host=''
engine=''
require_colima=0
require_lima=0

usage() {
  printf 'Usage: bash scripts/check-setup.sh [--source /path/to/openclaw-enterprise] [--engine docker|podman] [--docker-host unix:///path/to/docker.sock | --podman-host unix:///path/to/podman.sock] [--require-lima] [--require-colima]\n'
  printf 'Without --engine, installed engines are inventoried without selecting or requiring one.\n'
  printf 'Add --require-colima only when explicitly choosing the Colima VM path.\n'
  printf 'Add --require-lima when explicitly choosing the Lima VM path.\n'
  printf 'Without --source, pnpm/Go versions are reported but source compatibility is not checked.\n'
  printf 'Daemon inspection requires --engine and its matching explicit local socket argument.\n'
  printf 'Remote endpoints and implicit runtime connections are not contacted.\n'
}
while [ "$#" -gt 0 ]; do
  case "$1" in
    --source|--docker-host|--podman-host|--engine)
      if [ "$#" -lt 2 ] || [ -z "$2" ]; then usage >&2; exit 2; fi
      case "$1" in
        --source) source_path=$2;;
        --docker-host) docker_host=$2;;
        --podman-host) podman_host=$2;;
        --engine) engine=$2;;
      esac
      shift 2;;
    --require-colima) require_colima=1; shift;;
    --require-lima) require_lima=1; shift;;
    --help|-h) usage; exit 0;;
    *) usage >&2; exit 2;;
  esac
done
case "$engine" in
  ''|docker|podman) :;;
  *) printf 'GAP   --engine must select docker or podman; no engine was switched.\n'; exit 2;;
esac
if [ -n "$docker_host" ]; then
  if [ "$engine" != docker ]; then
    printf 'GAP   --docker-host requires an explicit --engine docker selection; no daemon was contacted.\n'
    exit 2
  fi
  case "$docker_host" in
    unix:///*) :;;
    *) printf 'GAP   --docker-host must select a local Unix socket; no network endpoint was contacted.\n'; exit 2;;
  esac
fi
if [ -n "$podman_host" ]; then
  if [ "$engine" != podman ]; then
    printf 'GAP   --podman-host requires an explicit --engine podman selection; no daemon was contacted.\n'
    exit 2
  fi
  case "$podman_host" in
    unix:///*) :;;
    *) printf 'GAP   --podman-host must select a local Unix socket; no network endpoint was contacted.\n'; exit 2;;
  esac
fi

gap() { printf 'GAP   %s\n' "$*"; failures=$((failures + 1)); }
check_command() {
  if command -v "$1" >/dev/null 2>&1; then
    printf 'OK    %s: %s\n' "$1" "$(command -v "$1")"
  else
    gap "$1 is missing"
  fi
}
# Python is also an upstream launcher prerequisite. Bound local inspections so
# an unavailable runtime or stalled plugin cannot hold the preflight open.
run_bounded() {
  if ! command -v python3 >/dev/null 2>&1; then return 125; fi
  PYTHONDONTWRITEBYTECODE=1 python3 -c '
import os, signal, subprocess, sys
try:
    child = subprocess.Popen(sys.argv[1:], start_new_session=True)
    try:
        result = child.wait(timeout=5)
        sys.exit(result if result >= 0 else 1)
    except subprocess.TimeoutExpired:
        os.killpg(child.pid, signal.SIGKILL)
        child.wait()
        sys.exit(124)
except OSError:
    sys.exit(125)
' "$@"
}
version_at_least() {
  awk -v actual="$1" -v required="$2" 'BEGIN {
    split(actual, a, "."); split(required, r, ".");
    for (i = 1; i <= 3; i++) {
      if (a[i] + 0 > r[i] + 0) exit 0;
      if (a[i] + 0 < r[i] + 0) exit 1;
    }
    exit 0;
  }'
}

printf 'OCE local setup: read-only preflight\n'
if [ -n "$engine" ]; then
  printf 'INFO  Selected container engine: %s\n' "$engine"
else
  printf 'NOTE  No container engine selected; inventory only. Select --engine after reviewing the approved existing runtime.\n'
fi
if [ "$(uname -s)" = Darwin ] && [ "$(sysctl -n hw.optional.arm64 2>/dev/null || printf 0)" = 1 ]; then
  printf 'OK    Apple Silicon Mac\n'
  if [ "$(uname -m)" != arm64 ]; then
    printf 'NOTE  Shell is translated; select native arm64 tools for this recipe.\n'
  fi
else
  gap 'This recipe qualifies an Apple Silicon Mac; other hosts need a separate recipe.'
fi
for tool in git bash python3 node pnpm go k3d kubectl helm; do
  check_command "$tool"
done
if [ -n "$engine" ]; then check_command "$engine"; fi
if [ "$require_colima" -eq 1 ]; then check_command colima; fi
if [ "$require_lima" -eq 1 ]; then check_command limactl; fi

node_requirement='>=24'
pnpm_requirement=''
go_requirement=''
if [ -n "$source_path" ]; then
  if [ ! -f "$source_path/package.json" ] || [ ! -f "$source_path/go.mod" ]; then
    gap 'Selected source must contain package.json and go.mod.'
  else
    if metadata=$(run_bounded node -e '
const fs = require("node:fs");
const p = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
const pm = /^pnpm@([0-9]+\.[0-9]+\.[0-9]+)(?:\+[^\s]+)?$/.exec(p.packageManager ?? "");
if (p.name !== "openclaw-enterprise" || typeof p.engines?.node !== "string" || !pm || /[\r\n]/.test(p.engines.node)) process.exit(1);
console.log(p.engines.node); console.log(pm[1]);
' "$source_path/package.json" 2>/dev/null); then
      node_requirement=$(printf '%s\n' "$metadata" | sed -n '1p')
      pnpm_requirement=$(printf '%s\n' "$metadata" | sed -n '2p')
      printf 'INFO  Selected source requires Node %s and pnpm %s\n' "$node_requirement" "$pnpm_requirement"
    else
      gap 'Cannot read OCE package requirements; Node/Python must work and source metadata must be valid.'
    fi
    go_requirement=$(awk '$1 == "go" {print $2; exit}' "$source_path/go.mod")
    if [[ "$go_requirement" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
      printf 'INFO  Selected source requires Go >=%s (go.mod)\n' "$go_requirement"
    else
      gap 'Cannot determine the Go requirement from selected source go.mod.'
      go_requirement=''
    fi
  fi
else
  printf 'NOTE  Pass --source after cloning to check its pnpm/Go requirements; no historical pin is assumed.\n'
fi
if command -v node >/dev/null 2>&1; then
  if node_version=$(run_bounded node --version 2>/dev/null); then
    printf 'INFO  Active Node: %s\n' "$node_version"
    if [[ "$node_requirement" =~ ^\>\=([0-9]+)(\.[0-9]+){0,2}$ ]]; then
      if [[ ! "${node_version#v}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
        ! version_at_least "${node_version#v}" "${node_requirement#>=}"; then
        gap "Active Node does not meet $node_requirement."
      fi
    else
      gap "Compare source Node range $node_requirement manually; this preflight supports numeric >= ranges."
    fi
  else
    gap 'Node version check failed or timed out.'
  fi
fi
if command -v pnpm >/dev/null 2>&1; then
  # Disable both Corepack and standalone pnpm package-manager downloads.
  pnpm_directory=${source_path:-$PWD}
  if pnpm_version=$(cd "$pnpm_directory" && run_bounded env COREPACK_ENABLE_AUTO_PIN=0 COREPACK_ENABLE_NETWORK=0 COREPACK_ENABLE_DOWNLOAD_PROMPT=0 npm_config_manage_package_manager_versions=false npm_config_userconfig=/dev/null npm_config_globalconfig=/dev/null pnpm --version 2>/dev/null); then
    printf 'INFO  Active pnpm: %s (downloads and auto-pin disabled)\n' "$pnpm_version"
    if [ -n "$pnpm_requirement" ] && [ "$pnpm_version" != "$pnpm_requirement" ]; then
      gap "Selected source requires pnpm $pnpm_requirement."
    fi
  else
    gap 'pnpm version check failed or timed out; install the source-selected manager through an approved path.'
  fi
fi
if command -v go >/dev/null 2>&1; then
  if go_version=$(run_bounded env GOTOOLCHAIN=local go version 2>/dev/null); then
    printf 'INFO  Active Go: %s (toolchain downloads disabled)\n' "$go_version"
    go_numeric=$(printf '%s\n' "$go_version" | awk '{sub(/^go/, "", $3); print $3}')
    if [ -n "$go_requirement" ] && { [[ ! "$go_numeric" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || ! version_at_least "$go_numeric" "$go_requirement"; }; then
      gap "Selected source requires Go >=$go_requirement."
    fi
  else
    gap 'Go version check failed or timed out.'
  fi
fi

if command -v docker >/dev/null 2>&1; then
  printf 'INFO  Installed Docker CLI: %s\n' "$(command -v docker)"
  if docker_version=$(run_bounded docker --version 2>/dev/null); then
    printf 'INFO  Active %s\n' "$docker_version"
  elif [ "$engine" = docker ]; then gap 'Selected Docker CLI version check failed or timed out.';
  else printf 'NOTE  Optional Docker CLI version check failed or timed out.\n'; fi
  if [ "$engine" = docker ]; then
    if save_help=$(run_bounded docker image save --help 2>/dev/null) && [[ "$save_help" == *'--platform'* ]]; then
      printf 'OK    Docker CLI supports image save --platform\n'
    else gap 'Active Docker CLI lacks image save --platform; select a compatible CLI before startup.'; fi
    if buildx_version=$(run_bounded docker buildx version 2>/dev/null); then
      printf 'OK    Docker buildx plugin: %s\n' "$buildx_version"
    else
      gap 'docker buildx is unavailable; configure the Docker CLI plugin before startup.'
      if command -v docker-buildx >/dev/null 2>&1; then
        printf 'NOTE  Standalone docker-buildx is installed, but that alone does not make docker buildx work.\n'
      fi
    fi
    if [ -n "$docker_host" ]; then
      if [ ! -S "${docker_host#unix://}" ]; then
        gap 'Selected Docker socket does not exist; verify the approved runtime before repeating the daemon check.'
      elif daemon=$(run_bounded env -u DOCKER_CONTEXT -u DOCKER_HOST -u DOCKER_TLS_VERIFY -u DOCKER_CERT_PATH docker --host "$docker_host" info --format '{{.ServerVersion}} {{.OSType}}/{{.Architecture}}; memory={{.MemTotal}} bytes; CPUs={{.NCPU}}' 2>/dev/null); then
        printf 'OK    Explicitly selected local Docker daemon: %s\n' "$daemon"
      else gap 'Selected local Docker daemon did not answer within five seconds.'; fi
    else
      printf 'NOTE  Docker daemon not checked; pass --docker-host with the intentionally selected local socket.\n'
    fi
  fi
  if contexts=$(run_bounded env -u DOCKER_CONTEXT -u DOCKER_HOST -u DOCKER_TLS_VERIFY -u DOCKER_CERT_PATH docker context ls --format '{{.Name}} (current={{.Current}})' 2>/dev/null); then
    printf 'INFO  Saved Docker contexts (process overrides ignored; unchanged):\n%s\n' "${contexts:-  none observed}"
  else printf 'NOTE  Docker context inventory failed or timed out; inspect it manually.\n'; fi
else printf 'INFO  Docker CLI is not installed.\n'; fi
if command -v colima >/dev/null 2>&1; then
  printf 'INFO  Optional Colima CLI: %s\n' "$(command -v colima)"
  if profiles=$(run_bounded colima list 2>/dev/null); then
    printf 'INFO  Existing Colima profiles (unchanged):\n%s\n' "${profiles:-  none observed}"
  else printf 'NOTE  Colima profile inventory failed or timed out; inspect it manually.\n'; fi
elif [ "$require_colima" -eq 0 ]; then
  printf 'NOTE  Colima is absent; it is needed only if choosing to create a Colima VM.\n'
fi
if command -v limactl >/dev/null 2>&1; then
  if lima_version=$(run_bounded limactl --version 2>/dev/null); then
    printf 'INFO  Installed %s\n' "$lima_version"
  elif [ "$require_lima" -eq 1 ]; then gap 'Selected Lima CLI version check failed or timed out.';
  else printf 'NOTE  Optional Lima CLI version check failed or timed out.\n'; fi
  if instances=$(run_bounded limactl list --format '{{.Name}} (status={{.Status}})' 2>/dev/null); then
    printf 'INFO  Existing Lima instances (unchanged):\n%s\n' "${instances:-  none observed}"
  else printf 'NOTE  Lima instance inventory failed or timed out; inspect it manually.\n'; fi
fi
if command -v podman >/dev/null 2>&1; then
  if podman_version=$(run_bounded podman --version 2>/dev/null); then
    printf 'INFO  Installed %s\n' "$podman_version"
  elif [ "$engine" = podman ]; then gap 'Selected Podman CLI version check failed or timed out.';
  else printf 'NOTE  Optional Podman CLI version check failed or timed out.\n'; fi
  if machines=$(run_bounded env -u CONTAINER_HOST -u CONTAINER_CONNECTION -u DOCKER_HOST -u DOCKER_CONTEXT podman machine list --format '{{.Name}} (running={{.Running}})' 2>/dev/null); then
    printf 'INFO  Existing Podman machines (local inventory only; unchanged):\n%s\n' "${machines:-  none observed}"
  else printf 'NOTE  Podman machine inventory failed or timed out; inspect it manually.\n'; fi
else printf 'INFO  Podman CLI is not installed.\n'; fi
if [ "$engine" = podman ]; then
  if [ -n "$podman_host" ]; then
    if [ ! -S "${podman_host#unix://}" ]; then
      gap 'Selected Podman socket does not exist; verify the approved runtime before repeating the daemon check.'
    elif daemon=$(run_bounded env -u CONTAINER_CONNECTION -u CONTAINER_HOST -u CONTAINER_PROXY -u DOCKER_CONTEXT -u DOCKER_HOST podman --remote --url "$podman_host" info --format json 2>/dev/null); then
      if report=$(printf '%s' "$daemon" | run_bounded python3 -c '
import json, re, sys
try:
    info = json.load(sys.stdin)
    host = info["host"]
    issues = []
    if host.get("security", {}).get("rootless") is not False:
        issues.append("selected Podman service must report rootless=false")
    if host.get("cgroupVersion") != "v2":
        issues.append("selected Podman service must report cgroup v2")
    if "cpuset" not in host.get("cgroupControllers", []):
        issues.append("selected Podman service must report the cpuset controller")
    if host.get("os") != "linux" or host.get("arch") not in ("arm64", "aarch64"):
        issues.append("selected Podman service must run Linux on ARM64 for this recipe")
    if issues:
        print("; ".join(issues))
        sys.exit(1)
    version = str(info.get("version", {}).get("Version", "unknown"))
    if not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+(?:[-+][A-Za-z0-9.-]+)?", version):
        version = "unknown"
    cpus = host.get("cpus")
    memory = host.get("memTotal")
    if type(cpus) is not int or type(memory) is not int or cpus < 1 or memory < 1:
        raise ValueError("invalid capacity")
    print(f"Podman {version}; linux/arm64; rootful; cgroup=v2; cpuset present; memory={memory} bytes; CPUs={cpus}")
except (KeyError, TypeError, ValueError, AttributeError):
    print("selected Podman service returned incomplete or invalid host information")
    sys.exit(1)
' 2>/dev/null); then
        printf 'OK    Explicitly selected local Podman service: %s\n' "$report"
      else gap "${report:-Selected Podman host metadata validation failed or timed out.}"; fi
    else gap 'Selected local Podman service did not answer within five seconds.'; fi
    printf 'NOTE  Engine metadata does not prove k3d startup, image builds/imports, mounted state, forwarding or Agent sandbox acceptance; qualify those during installation.\n'
  else
    printf 'NOTE  Podman daemon, rootful mode, cpuset/cgroup support and host-reachable API socket are not checked.\n'
    printf 'NOTE  Pass --podman-host with the intentionally selected local socket; this preflight did not contact the current connection.\n'
  fi
fi
if [ -z "$engine" ]; then
  printf 'NOTE  Engine compatibility and daemon acceptance are pending; no daemon was contacted.\n'
fi
for tool in k3d kubectl helm; do
  if ! command -v "$tool" >/dev/null 2>&1; then continue; fi
  case "$tool" in
    k3d) version=$(run_bounded k3d version 2>/dev/null);;
    kubectl) version=$(run_bounded kubectl version --client --output=yaml 2>/dev/null | awk '$1 == "gitVersion:" {print $2; exit}');;
    helm) version=$(run_bounded helm version --short 2>/dev/null);;
  esac
  if [ -n "$version" ]; then printf 'INFO  %s: %s\n' "$tool" "$version";
  else gap "$tool client version check failed or timed out."; fi
done

if [ "$(uname -s)" = Darwin ]; then
  memory_bytes=$(sysctl -n hw.memsize 2>/dev/null || printf 0)
  cpus=$(sysctl -n hw.logicalcpu 2>/dev/null || printf 0)
  printf 'INFO  Host capacity: %s GiB RAM; %s logical CPUs\n' "$((memory_bytes / 1024 / 1024 / 1024))" "$cpus"
  if [ "$memory_bytes" -lt 21474836480 ]; then
    printf 'NOTE  The working VM allocation is 14 GiB RAM; leave adequate memory for macOS and CSB services.\n'
  fi
fi
storage_path=${source_path:-$HOME}
if [ ! -d "$storage_path" ]; then storage_path=$HOME; fi
free_kib=$(df -Pk "$storage_path" | awk 'END {print $4}')
case "$free_kib" in
  ''|*[!0-9]*) printf 'NOTE  Inspect free host storage manually.\n';;
  *) printf 'INFO  Free host storage: %s GiB (60 GiB is planning headroom)\n' "$((free_kib / 1024 / 1024))"
     if [ "$free_kib" -lt 62914560 ]; then printf 'NOTE  Free storage is below the planned build headroom; review capacity before startup.\n'; fi;;
esac
if command -v lsof >/dev/null 2>&1; then
  for port in "${OPENCLAW_DEV_PORT:-3300}" "${OCC_DEVELOPMENT_BROWSER_PORT:-8444}" "${OCC_DEVELOPMENT_KUBERNETES_API_PORT:-6444}"; do
    if [[ ! "$port" =~ ^[0-9]+$ ]] || [ "${#port}" -gt 5 ] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
      gap "Invalid selected port: $port"
    elif run_bounded lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
      printf 'NOTE  Port %s is occupied; select an unused port for a fresh setup. Do not stop its service.\n' "$port"
    else
      result=$?
      if [ "$result" -eq 1 ]; then printf 'OK    No listener observed on port %s (recheck before startup)\n' "$port";
      else printf 'NOTE  Port %s could not be inspected; check manually before startup.\n' "$port"; fi
    fi
  done
else printf 'NOTE  lsof is unavailable; inspect selected ports manually.\n'; fi
printf 'This check changed no runtime, context or service and did not provision OCE or exercise a model.\n'
if [ "$failures" -gt 0 ]; then
  printf 'Result: %s prerequisite gaps\n' "$failures"
  exit 1
fi
printf 'Result: inspected prerequisites present; source/daemon checks may be pending and installation acceptance is still required.\n'
