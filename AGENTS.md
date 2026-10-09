# Agent instructions

Personal agent setup. This file is symlinked to `~/.config/opencode/AGENTS.md` and
`~/.codex/AGENTS.md`, and is read by any harness that follows the AGENTS.md convention.
Claude Code reads `~/.claude/CLAUDE.md` instead, which the same repo provides.

## Skills

Skills live in `~/.agents/skills/`. Each skill is a directory holding a `SKILL.md`.
opencode reads that path directly. Claude Code reads `~/.claude/skills/` and codex reads
`~/.codex/skills/`, so each skill is symlinked into both, either by `install.sh` or by
the Home Manager module in `flake.nix`.

## Writing

The `unslop` skill in `skills/unslop/SKILL.md` applies to every response, not only to
text you are asked to edit. Read it and run its pre-send check before sending. Claude
Code loads it automatically through `@unslop.md` in `claude/CLAUDE.md`.

## UI work

Four vendored skills filter generated interfaces. `antislop` is the core filter,
`antislop-ui` covers color, layout, components and motion, `antislop-layoutmobile`
covers responsive reflow, and `antislop-human` covers contrast, keyboard use and UI
states. Load the core plus whichever depth skills the task needs before building,
editing or auditing any interface. They load on demand, so they cost nothing on a
session that never touches UI.

The core filters; it does not supply taste. It needs direction to work against: a
`DESIGN.md` or a written brief in the repo. Without one, say the output is a draft
rather than presenting it as finished.

Copy and prose stay with `unslop`. `antislop-copywriting` is deliberately not
vendored, because the two rule sets overlap almost line for line.

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
