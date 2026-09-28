---
name: my-ai-tools
description: See which AI tools you use in Claude — connectors, skills, plugins, projects — check they're set up properly, and share them with your organisation's AI register. Use for "what AI tools do I have", "what's connected", "is my setup right", "add my tools to the register", "my AI lead asked everyone to share their tools", or when someone has been asked to take part in an AI tools review.
---

# My AI tools

For anyone in the organisation. Most people's AI setup has grown one connector and one skill
at a time, and nobody, including them, has the full picture. This skill shows them theirs,
fixes what's half set up, and, with their say-so, adds it to the organisation's AI register
so the AI lead can see what's actually in use.

**It is theirs to share.** Nothing is recorded until they have seen the list and agreed.
That isn't a courtesy: a register built by quietly reading people's setups is the thing
this is not.

## 1. Say what you'll do, and what you won't

Before looking at anything, tell them in two or three sentences:

- You'll list the connectors, skills, plugins and projects **this session** can see.
- Only **names and ids** get recorded. You won't read or record what's inside a skill, a
  project or a conversation.
- They'll see the list first and choose what to share. Anything personal stays out unless
  they say otherwise.

Then ask whether to go ahead. If they'd rather just see their setup without sharing
anything, do steps 2 and 5 and skip the rest.

## 2. List what this session uses

Work from what you can actually see in this session, not from memory or guesses:

- **Connectors** — each one's name, and its installed server id when the surface shows one
  (a UUID). Note its state: connected, needs authorising, disconnected, setup not finished.
- **Plugins** — name and `plugin_…` id, and the skills inside each.
- **Skills** — account skills with their `skill_…` id; Anthropic's own skills by name.
- **Projects** — you will usually see an id but not a name.

**Leave out** built-in and local tools: memory, the file system, the browser, widgets,
anything running on their own computer. They aren't the organisation's AI estate.

**Never describe what's in a project, a skill or a chat.** A project shows you an id and its
contents; record the id only, and ask the user what it's called. If you can tell a project
is personal, don't list it for sharing at all.

Show the list grouped by kind, with anything that needs attention marked. Keep it scannable:
a table per kind, or a short list, not a paragraph per item.

## 3. Let them choose

Ask which to share. Make it easy: "all of these, except …" is the usual answer.

- **Personal things are out by default.** A connector to their own Gmail, a personal
  project, a skill they wrote for home. Offer once, plainly: sharing a personal tool as
  *personal* helps the AI lead see where people are using their own accounts for work, but
  it is their call.
- **Anything they haven't seen, you don't send.**

## 4. Record it, and keep this pass quick

Call **`kowalah_record_ai_assets`** with `surface` set to where this session runs
(`claude_ai`, `claude_desktop`, `cowork`, `claude_code`) and the items they chose:

- `kind`, `name`, and `external_ref` whenever there is an id. The id is how the register
  recognises the same tool next time, and across Cowork and Claude Code.
- Plugins **before** the skills inside them, with `parent_external_ref` on each skill.
- `connection_status` on connectors.
- `scope: "user"` on the personal items they chose to share.

You don't need to say which platform anything runs on: what this session uses is put on
Claude automatically, and each connector is linked to the system it's named for.

The response has one short line per item: **new** or **seen again**, its gaps, and
`ask: true` on the ones nobody has described yet (`ask_about` is how many). For those, ask
**one** quick question in this pass: is it just them, their team, or provided to everyone?
That's `scope`. Everything else waits for part two.

This first pass has to stay fast, or people won't run it. Someone running it for the
second time should be done in a minute.

**Decisions aren't theirs to make for everyone.** Owner, status and organisation-wide scope
are decided by admins and core team (or the tool's owner). If a member's answer is refused,
the tool is still recorded as used; say that their AI lead will pick it up.

## 5. Part two: what each tool does (when there's time)

A register of names says what exists, not what it does. Part two fills that in, and it's
**separate** from the first pass so capture stays quick. Offer it at the end ("have you got
five minutes to say what a few of these are for?"), run it on a re-run, or when the AI lead
asks from `ai-estate`. Never make it a condition of sharing.

Work only on items with gaps, a few at a time, **organisation-wide and live ones first**:

- **What's it for?** Their words become `description`. Never write one yourself from what a
  skill or tool contains.
- **Does it do a job in one of the organisation's processes?** If so, which step: find it
  with `kowalah_get_process` and pass `serves_step_ids`. This is how "Brian drafts the
  replies" becomes a real record on that step. `kowalah_get_ai_estate` lists
  `suggested_step_links`, steps that already name the tool in their text, so start there
  and ask the person to confirm each one.
- **Whose login does it run on, and can it act** (send, sign, write) **or only read?** There
  isn't a field for this yet (KOW-379). If it comes up, note it in `notes`, in their words.

Stop when they've had enough. Whatever's left shows as a gap for next time.

## 6. Give something back

This is why it's worth their time. From what you listed:

- **Connectors that need authorising or have disconnected** — name them and say how to fix
  it (Settings → Connectors). Installed-but-never-connected is common and usually an
  oversight.
- **Duplicates** — the same skill in several plugins, or an account skill that a plugin
  now provides.
- **Something already exists** — if they described a job a tool of theirs half-does, check
  `kowalah_find_accelerator`; there may be a better one off the shelf.
- **The organisation's position** — if a tool they use sits on a platform the systems
  register shows as unreviewed or prohibited (`kowalah_get_systems`), tell them straight.
  Not as a telling-off: they are the reason the AI lead can now sort it out.

Close with one line: what was shared, and what (if anything) they should do next.

## Running it again

People's setups change. Running this again is how the register stays current: known tools
are simply "seen again", and only new ones get questions. There is no background version of
this skill. If the AI lead wants a refresh, `ai-estate` shows what has gone quiet and they
ask the team to run it.

## Scope and permissions

Anyone in the organisation can share their tools. Everyone can read the register with
`kowalah_get_ai_estate`, but others' use shows as counts, not names, unless you are an
admin or core team.

If the user belongs to more than one Kowalah organisation, pass `organization_id`. Call
`kowalah_get_update` with no query to list their organisations, then ask which one.
