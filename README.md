# Kowalah plugin for Claude

Run an AI operating model programme from inside Claude.

Kowalah is a managed AI advisory programme. Client organisations map their business as an
**AI Operating Model** — an org tree of real processes, broken into steps, each with an
owner, a quality bar, and a decision about whether a human or an AI runs it. This plugin
puts that model into Claude, along with the judgement needed to read it honestly.

> **Sign up with your work email address.** Signing in creates an account if you don't have
> one — no invitation needed — and places you in an organisation, because every Kowalah
> account belongs to one. If your company's domain is registered with Kowalah, that's your
> company's organisation and everything works. If it isn't, you get a brand-new empty
> organisation of your own instead, and every tool will return valid but empty results
> until someone attaches you to the right one. See [kowalah.com](https://kowalah.com).

## Install

```
/plugin marketplace add kowalah-dev/kowalah-plugin
/plugin install kowalah@kowalah
```

On first use, Claude prompts you to sign in or sign up — use your work email address. Then
ask "what's my Kowalah status": that runs the setup check, which tells you which
organisation you landed in, what your role can see, and whether it's your company's real
organisation or a new empty one.

## Who it's for

**AI programme leads and core teams** — the people accountable for AI across an
organisation or a division. Where is the business actually constrained, is the work in
flight aimed there, and what should happen next.

**Process owners** — the people who own a real business process and have to decide what AI
changes about it. Where does the cycle time go, does this need redesigning or just
automating, and how do we know the AI is doing it right.

**Everyone else** — the people with default access who have no formal role in the model.
An AI lead can roll the plugin out company-wide and tell people to talk through their own
work and log what's worth doing. Members can read the whole operating model and vision, and
can propose against any process they can see.

## Skills

| Skill | What it does |
|---|---|
| `/kowalah:programme-review` | Coverage, where constraints concentrate, and whether in-flight work is aimed at the actual gaps. Tests everything against the organisation's AI vision map. |
| `/kowalah:process-diagnostic` | Reads one process honestly — where cycle time really goes, how many handoffs, and what has never been measured. Treats a missing measurement as a finding, not a zero. |
| `/kowalah:process-redesign` | As-is to to-be. Mark up what gets eliminated, merged or kept, then generate the redesign beside the original so the two can be compared. |
| `/kowalah:quality-bar` | Acceptance criteria, gates and monitors, target scores — what "good" means for a step, set by the business owner rather than the builder. |
| `/kowalah:kowalah-setup` | Connect the MCP server and work out what your account can actually see — including whether you landed in your company's organisation or a new empty one. |
| `/kowalah:spot-opportunities` | For anyone: talk through your own work, find the real friction, check what already exists, and route it. Grounded in your organisation's vision, not generic AI advice. |
| `/kowalah:raise-opportunity` | Check the accelerator library first, test against the vision, score it, submit it. |

Skills activate on their own when the context fits; the slash commands are there when you
want to be explicit.

## Two ideas worth knowing before you start

**The model is the context layer — the skills read it before they ask you anything.** Your
operating model already holds the owners, steps, timings, constraints and quality bars, so
the skills are written to look there first and only ask for what's genuinely missing. Where
something isn't recorded, they say so rather than filling the gap from conversation, and
they check how old the vision and the quality readings are before leaning on them.

**You can see more than you can change.** Reads are scoped to your organisation, not your
role — anyone can look at the whole operating model and the vision map. Writes are
permission-checked, and where you can't edit something the tools route you to a proposal
instead of refusing. So the always-open path for everyone is: see anything, propose
anything.

**A null is "can't say", never "none".** Process diagnostics return nulls where the data is
incomplete — handoff counts when a step has no owner, cycle ratios when a step has never
been timed. The skills are written to surface those absences rather than round them to
zero, because an unmeasured process reading as a clean one is the failure mode that costs
the most.

**Work is measured in minutes. Processes are measured in days.** A process that is 0.4%
work and 99.6% waiting cannot be fixed by making the work faster. The diagnostic leads with
that ratio wherever the data supports it, because it usually reframes the whole
conversation.

## What's in here

```
.claude-plugin/
  plugin.json          Plugin manifest
  marketplace.json     Marketplace manifest — lets this repo be added directly
.mcp.json              Registers mcp.kowalah.com as an authenticated HTTP connector
skills/                Seven skills, one directory each — including `setup`,
                       which covers connecting and troubleshooting
```

The MCP server itself is not in this repo — it's a remote HTTP connector at
`mcp.kowalah.com`, built and operated by Kowalah. This plugin registers it and adds the
skills that use it.

## Tools this plugin connects to

Read: `kowalah_get_vision`, `kowalah_get_operating_model`,
`kowalah_get_operating_model_unit`, `kowalah_get_process`, `kowalah_get_update`,
`kowalah_get_my_training`, `kowalah_find_accelerator`

Write: `kowalah_save_process`, `kowalah_save_process_step`,
`kowalah_save_process_step_eval`, `kowalah_save_org_unit`, `kowalah_propose_redesign`,
`kowalah_propose_process_change`, `kowalah_create_opportunity`

All writes are permission-checked against the caller's role and position in the org tree.
Where a user can't edit something directly, the tools route them to a proposal instead of
refusing.

## Data and privacy

The connector authenticates via OAuth and scopes every query to the organisations the
signed-in user is an accepted member of. Clients never see other clients' data, and several
internal fields are stripped before anything reaches Claude. See
[kowalah.com/privacy](https://kowalah.com/privacy).

## Support

Issues with the plugin: open an issue on this repo.
Anything about your Kowalah programme: your Kowalah team.

MIT licensed.
