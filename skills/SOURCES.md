# Skill provenance

Where each vendored skill came from, so a later upstream change can be diffed against
what is here. All three upstream repos are MIT licensed.

| upstream | commit | vendored on |
|---|---|---|
| [mattpocock/skills](https://github.com/mattpocock/skills) | `c55ee46073ed` | 2026-09-23 |
| [cursor/plugins](https://github.com/cursor/plugins) (pstack) | `b42effe0aa50` | 2026-09-23 |
| [miqdadbadjuber/anti-slop](https://github.com/miqdadbadjuber/anti-slop) | `388cbe3b6c37` (v3.2.20) | 2026-10-09 |

## From cursor/plugins, path `pstack/skills/`

| skill | note |
|---|---|
| `how` | |
| `why` | |
| `principle-encode-lessons-in-structure` | |
| `principle-prove-it-works` | |
| `teach` | invokes `how`, `why`, and `unslop` |
| `show-me-your-work` | |
| `unslop` | vendored earlier, `disable-model-invocation` removed locally |

## From mattpocock/skills, path `skills/engineering/`

| skill | note |
|---|---|
| `domain-modeling` | |
| `diagnosing-bugs` | |
| `wayfinder` | needs an issue tracker, see below. invokes `prototype` and `research` |
| `wizard` | |
| `grill-with-docs` | invokes `grilling` and `domain-modeling` |
| `improve-codebase-architecture` | invokes `codebase-design`, `domain-modeling`, `grilling` |
| `prototype` | `UI.md` points at `antislop` and `antislop-ui` (local edit) |
| `codebase-design` | dependency of `improve-codebase-architecture` |
| `research` | dependency of `wayfinder` |

## From mattpocock/skills, path `skills/productivity/`

| skill | note |
|---|---|
| `writing-for-agents` | |
| `grilling` | dependency of `grill-with-docs` and `improve-codebase-architecture` |

## From miqdadbadjuber/anti-slop, path `skills/`

| skill | note |
|---|---|
| `antislop` | the core filter, edited locally, see below |
| `antislop-ui` | color, layout, components, decoration, motion |
| `antislop-layoutmobile` | responsive reflow, overflow, tap targets |
| `antislop-human` | contrast, keyboard, focus, UI states. Ships `contrast-check.py` |

Upstream ships two more, both skipped. `antislop-copywriting` overlaps `unslop` almost
line for line, and two competing prose rule sets is worse than one. `antislop-code`
covers code-comment hygiene only, which no current skill needs.

Local edits to `antislop/SKILL.md`:

- Dropped the First-Run Install Wizard, which appends a pointer block to `CLAUDE.md`
  and walks the user through `npx antislop-ai`. `install.sh` and the routing in
  `AGENTS.md` already do that job, and the wizard would rewrite instruction files.
- Replaced Two Usage Modes with a six-line Two Modes section. Upstream reads
  `~/.config/antislop/settings.json`, asks a during-or-after question every session,
  and announces a resolved mode with its source. The mode is inferable from the task.
- Pointed every `antislop.md` reference at the skill names, since the four live as
  sibling skill directories here rather than one file plus a `skills/` subfolder.
- Dropped the R-02 carve-out clause naming the copywriting skill, which is not vendored.

All four: dropped the `allowed-tools` frontmatter field. Upstream writes it
space-separated (`Read Write Edit Glob Grep`), which no harness here parses as a list.
Dropped `contrast-mcp.py`, which only runs through the upstream plugin's MCP launcher.

`contrast-check.py` needs a `python3` on PATH. This machine has none, so the checker
falls back to the formula and reference table in `antislop-human/SKILL.md`, which the
skill says is complete on its own.

## Local, not vendored

`herdr`, `sessionizer-layout-editor`, `i-have-adhd`.
`i-have-adhd` is an edit of [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd),
MIT, reworked to compose with `unslop`.

## Setup still needed

`wayfinder` reads and writes decision tickets on a repo issue tracker. Run
`/setup-matt-pocock-skills` once inside a repo before using it, or it has nowhere to
write. Every other skill works with no setup.

## Refreshing

These are vendored copies, not submodules. To update, re-download the upstream tarball,
copy the skill directory over, and bump the commit in the table above.
