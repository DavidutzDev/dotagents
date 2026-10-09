# dotagents

One repo for my agentic setup: skills and global instructions, shared across every
coding agent on every machine.

Clone it to `~/.agents` and run `./install.sh`, or add the flake to a Nix config, and
Claude Code, codex, opencode and anything driving them see the same skills.

## Why `~/.agents`

`~/.agents/skills/` is the cross-harness location for skills. Cloning the repo there
means opencode needs no configuration at all.

| Harness | Reads `~/.agents/skills/` | What install.sh does |
| --- | --- | --- |
| opencode | yes, directly | nothing, it already works |
| Claude Code | no, it only loads `~/.claude/skills/` | symlinks each skill into `~/.claude/skills/` |
| codex | no, it reads `~/.codex/skills/` | symlinks each skill into `~/.codex/skills/`, and `AGENTS.md` into `~/.codex/AGENTS.md` |
| t3code | not applicable | it drives the `claude` and `opencode` CLIs, so it inherits their setup |
| gemini | no | uses extensions, not `SKILL.md` |

Instructions follow the same idea. opencode reads `~/.config/opencode/AGENTS.md` and
`~/.claude/CLAUDE.md`. Claude Code reads `~/.claude/CLAUDE.md`, and codex reads
`~/.codex/AGENTS.md`. `install.sh` points every one of them at files in this repo.

## Layout

    skills/           one directory per skill, each with a SKILL.md
    claude/CLAUDE.md  global Claude Code instructions
    claude/RTK.md     RTK reference, imported by CLAUDE.md via @RTK.md
    AGENTS.md         harness-neutral instructions
    install.sh        idempotent symlink installer
    flake.nix         Home Manager module, for machines managed by Nix
    nix/              the module itself

## Two ways to install

Pick one per machine. Running both means `install.sh` replaces the symlinks Home
Manager owns, and the next activation moves them aside as `<name>.hm-backup`. Inside
`~/.claude/skills/` that leaves a second copy of every skill, which the agent loads.

### install.sh, on a machine without Nix

    git clone git@github.com:DavidutzDev/dotagents.git ~/.agents
    ~/.agents/install.sh

Run `./install.sh --dry-run` first to see the changes without writing anything.

The installer is idempotent, so re-run it after every `git pull`. A file it has to
replace is moved to `~/.agents-backup/<timestamp>/` rather than renamed in place,
because a `skill.bak` directory sitting inside `skills/` would load as a duplicate
skill.

### The flake, on a machine managed by Nix

Add the input and import the module. It links the same files `install.sh` does, so
nothing has to run after a `git pull`:

    inputs.dotagents.url = "github:DavidutzDev/dotagents";

    # in a Home Manager config
    imports = [ inputs.dotagents.homeModules.default ];

The flake has no inputs of its own, so there is no second nixpkgs to follow. The module
takes `lib` from the host config.

Options, all under `dotagents`:

| option | default | what it does |
| --- | --- | --- |
| `enable` | `true` | importing the module is the whole opt-in |
| `claude.enable` | `true` | links `~/.claude/skills/*`, `CLAUDE.md`, `RTK.md`, `unslop.md` |
| `codex.enable` | `true` | links `~/.codex/skills/*` and `~/.codex/AGENTS.md` |
| `opencode.enable` | `false` | links `~/.config/opencode/skill/*` and its `AGENTS.md`. Off because turning it on creates the directory whether or not opencode is installed |
| `skills` | every directory under `skills/` | which skills to link |
| `src` | the flake itself | point it at a working tree to test an edit without committing |

Skills are linked one at a time rather than as one link over the parent directory,
because Claude Code writes `~/.claude/skills/synced/` itself and a link over the parent
would hide it.

## Add a skill

    mkdir -p ~/.agents/skills/my-skill
    $EDITOR ~/.agents/skills/my-skill/SKILL.md
    ~/.agents/install.sh
    git add -A && git commit -m "add my-skill" && git push

`SKILL.md` needs YAML frontmatter with `name` and `description`. The description is what
the agent matches against when it decides whether to load the skill, so write it as a
trigger condition rather than a summary.
