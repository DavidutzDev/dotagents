# Agent instructions

Personal agent setup. This file is symlinked to `~/.config/opencode/AGENTS.md` and is
read by any harness that follows the AGENTS.md convention. Claude Code reads
`~/.claude/CLAUDE.md` instead, which the same repo provides.

## Skills

Skills live in `~/.agents/skills/`. Each skill is a directory holding a `SKILL.md`.
opencode reads that path directly. Claude Code only loads `~/.claude/skills/`, so
`install.sh` symlinks each skill into it.

## Writing

The `unslop` skill in `skills/unslop/SKILL.md` applies to every response, not only to
text you are asked to edit. Read it and run its pre-send check before sending. Claude
Code loads it automatically through `@unslop.md` in `claude/CLAUDE.md`.

## RTK, the Rust Token Killer

`rtk` is a CLI proxy that cuts token use on dev commands by 60 to 90 percent. In Claude
Code a hook rewrites commands automatically, so `git status` becomes `rtk git status` with
no extra tokens. In harnesses without that hook, call `rtk` yourself.

    rtk gain              show token savings
    rtk gain --history    command history with savings
    rtk discover          find missed opportunities in Claude Code history
    rtk proxy <cmd>       run a raw command with no filtering

Check the install with `rtk --version`. If `rtk gain` reports an unknown command, the
binary on PATH is reachingforthejack/rtk (Rust Type Kit), a different project with the
same name.

Full reference: `claude/RTK.md` in this repo.
