# Agent-led setup: 2026 references

**Give your coding agent [setup.md](https://redhat-et.github.io/openclaw-enterprise-onboarding/setup.md) and an explicit installation request.** Use [llms.txt](https://redhat-et.github.io/openclaw-enterprise-onboarding/llms.txt) to discover the packet. The existing human and detailed agent guides remain available.

Reviewed **October 2, 2026**. The compared projects have more than 100,000 GitHub stars and open-source licenses. Counts are a dated GitHub API snapshot, not a continuing popularity guarantee. The comparison uses 2026 announcements or repository changes; it does not imply these projects endorse OCE or share one installation protocol.

## Current large-project examples

| Project and star snapshot | 2026 primary evidence | Pattern adopted here |
| --- | --- | --- |
| [Next.js](https://github.com/vercel/next.js), **143,004** | [March 18 agent-ready development](https://nextjs.org/blog/next-16-2-ai); [June 26 AI improvements](https://nextjs.org/blog/next-16-3-ai-improvements); [September 22 instruction-generator change](https://github.com/vercel/next.js/commit/43f54d52f8092499d2e9b57e93651129cce5f0d3) | Version-matched `AGENTS.md` and task instructions. March documented a Claude import; September's generator removed the alias for direct `AGENTS.md` loading. We retain an explicit import for client/version compatibility, select current OCE source and record the resolved revision for each run. |
| [shadcn/ui](https://github.com/shadcn-ui/ui), **124,986** | [March CLI v4](https://ui.shadcn.com/docs/changelog/2026-03-cli-v4); [July 10 llms.txt change](https://github.com/shadcn-ui/ui/commit/3cdaa6eb2f0da27aca8598cb752c32d840e06940) | [Small discovery index](https://ui.shadcn.com/llms.txt), [procedural agent skills](https://ui.shadcn.com/docs/skills) and a CLI the agent drives. Our first script is a readable, read-only preflight; the runbook carries installation commands. |
| [Supabase](https://github.com/supabase/supabase), **110,999** | [April 9 Agent Skills release](https://supabase.com/blog/supabase-agent-skills); [September 28 Markdown/agent-guidance change](https://github.com/supabase/supabase/commit/49da804baaac5efae78cb8255377499c1c2aea01) | [llms.txt](https://supabase.com/llms.txt) points to task-specific Markdown and skills. Our index links only the public brief, runbook, preflight and reference files. |

Star counts identify examples, not evidence that a setup flow works. Each operator must verify their installation and model reply. We excluded n8n from this open-source comparison because its fair-code licensing differs from the qualifying projects.

## What is standard and what is a project choice?

| File or format | Purpose | Status and source |
| --- | --- | --- |
| `llms.txt` | Small web documentation map; agents follow relevant links. | [Open proposal, v2](https://llmstxt.org/), updated **August 10, 2026**. It supports GitHub Pages project subpaths and discovery links. Fetching it does not run commands. |
| `AGENTS.md` | Repository context, setup/build commands and contributor instructions. | [Open convention](https://agents.md/), without a required schema. It does not authorize an installation by its mere presence. |
| `setup.md` | An execution brief for this particular requested OCE task. | Our filename and contract, not a claimed universal standard. It links the detailed runbook and defines inputs and evidence. |
| `SKILL.md` | Portable packaged procedural instructions with optional scripts/resources. | [Agent Skills format](https://agentskills.io/specification). Useful for repeated workflows; this repository currently publishes a directly readable packet rather than requiring a skill installation. |
| Shell script | Explicit executable automation. | Project-specific behavior. Our [check-setup.sh](https://github.com/redhat-et/openclaw-enterprise-onboarding/blob/main/scripts/check-setup.sh) performs first preflight only; no remote pipe-to-shell installer is required. |

## Client entry points

Paste the setup URL with an instruction to perform the task into a terminal-capable Claude Code, Codex, Cursor or equivalent agent. A URL alone does not guarantee discovery, local execution or completion.

The repository has `AGENTS.md`; `CLAUDE.md` explicitly imports `@AGENTS.md` to avoid duplicating policy. Client/version/ancestor-file rules still apply: see [Claude Code memory](https://code.claude.com/docs/en/memory#agents-md), [Cursor rules](https://cursor.com/docs/rules) and the [AGENTS.md ecosystem](https://agents.md/). Explicitly requesting that the agent read `setup.md` works independently of automatic repository-file discovery.

The Pages site exposes `rel="describedby"` for its project-scoped index and a Markdown alternative. `llms-full.txt` is generated from `setup.md` plus the detailed runbook, avoiding a separately edited copy. Self-contained SVG diagrams keep the architecture visible without remote diagram libraries.

## Acceptance

Documentation checks establish that links, diagrams, public-content boundaries, syntax and site publishing work. They do not demonstrate a new OCE installation. Initial preflight inventories available runtimes without selecting an engine. It optionally checks an explicitly selected local Podman socket through **`--engine podman` plus `--podman-host`** (rootful/cgroup metadata), or a Docker socket through **`--engine docker` plus `--docker-host`**. `--require-lima` checks the selected recipe's local Lima prerequisite, and `--source` reads checkout toolchain requirements. It does not create infrastructure or prove builds, image imports, mounts, forwarding, sandbox checks, Kubernetes readiness, console authentication or a model. The setup brief requires those later checks and distinguishes platform readiness, prompt acceptance and genuine native-tool evidence.
