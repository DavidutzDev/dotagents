# dotagents

One repo for my agentic setup: skills and global instructions, shared across every
coding agent on every machine.

Clone it to `~/.agents`, run `./install.sh`, and Claude Code, opencode and anything
driving them see the same skills.

## Why `~/.agents`

`~/.agents/skills/` is the cross-harness location for skills. Cloning the repo there
means opencode needs no configuration at all.

| Harness | Reads `~/.agents/skills/` | What install.sh does |
| --- | --- | --- |
| opencode | yes, directly | nothing, it already works |
| Claude Code | no, it only loads `~/.claude/skills/` | symlinks each skill into `~/.claude/skills/` |
| t3code | not applicable | it drives the `claude` and `opencode` CLIs, so it inherits their setup |
| gemini | no | uses extensions, not `SKILL.md` |

Instructions follow the same idea. opencode reads `~/.config/opencode/AGENTS.md` and
`~/.claude/CLAUDE.md`. Claude Code reads `~/.claude/CLAUDE.md`. `install.sh` points all
three at files in this repo.

## Layout

    skills/           one directory per skill, each with a SKILL.md
    claude/CLAUDE.md  global Claude Code instructions
    claude/RTK.md     RTK reference, imported by CLAUDE.md via @RTK.md
    AGENTS.md         harness-neutral instructions
    install.sh        idempotent symlink installer

## Set up a new machine

    git clone git@github.com:DavidutzDev/dotagents.git ~/.agents
    ~/.agents/install.sh

Run `./install.sh --dry-run` first to see the changes without writing anything.

The installer is idempotent, so re-run it after every `git pull`. A file it has to
replace is moved to `~/.agents-backup/<timestamp>/` rather than renamed in place,
because a `skill.bak` directory sitting inside `skills/` would load as a duplicate
skill.

## Add a skill

    mkdir -p ~/.agents/skills/my-skill
    $EDITOR ~/.agents/skills/my-skill/SKILL.md
    ~/.agents/install.sh
    git add -A && git commit -m "add my-skill" && git push

`SKILL.md` needs YAML frontmatter with `name` and `description`. The description is what
the agent matches against when it decides whether to load the skill, so write it as a
trigger condition rather than a summary.

## Not tracked here

`graphify` stays a real directory in `~/.claude/skills/`. It ships its own updater and
version file, which would fight a symlink. `install.sh` leaves it alone.
