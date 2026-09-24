# Skill provenance

Where each vendored skill came from, so a later upstream change can be diffed against
what is here. Both upstream repos are MIT licensed.

| upstream | commit | vendored on |
|---|---|---|
| [mattpocock/skills](https://github.com/mattpocock/skills) | `c55ee46073ed` | 2026-09-23 |
| [cursor/plugins](https://github.com/cursor/plugins) (pstack) | `b42effe0aa50` | 2026-09-23 |

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
| `prototype` | |
| `codebase-design` | dependency of `improve-codebase-architecture` |
| `research` | dependency of `wayfinder` |

## From mattpocock/skills, path `skills/productivity/`

| skill | note |
|---|---|
| `writing-for-agents` | |
| `grilling` | dependency of `grill-with-docs` and `improve-codebase-architecture` |

## Local, not vendored

`herdr`, `sessionizer-layout-editor`, `i-have-adhd`.
`i-have-adhd` is an edit of [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd),
MIT, reworked to compose with `unslop`.

## Setup still needed

`wayfinder` reads and writes decision tickets on a repo issue tracker. Run
`/setup-matt-pocock-skills` once inside a repo before using it, or it has nowhere to
write. The other 16 skills work with no setup.

## Refreshing

These are vendored copies, not submodules. To update, re-download the upstream tarball,
copy the skill directory over, and bump the commit in the table above.
