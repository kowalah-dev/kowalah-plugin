---
name: ai-estate
description: Review and maintain the organisation's AI estate — which AI tools and platforms it actually has, what people have built and switched on in them (connectors, skills, plugins, projects, agents), how each is held (licences, seats, contracts, DPAs), which are unsanctioned or risky, what renews soon, and where each is used in the business. Use for "what AI tools do we have", "what's our shadow AI", "which tools train on our data", "what renews this quarter", "is ChatGPT approved", "add Granola to the register", or any audit of AI tools and licences.
---

# AI estate

For the AI Ops lead, the core team, the CIO or whoever is accountable for which AI the
organisation uses. The first question they have to answer is **what have we actually got**,
and the second is **what should we worry about**. This skill answers both from the systems
register, and keeps the register true.

## Read the register before you ask

**`kowalah_get_systems`** returns the register: every system, whether it has AI in it,
how the organisation holds it (arrangements), how many live process steps use it, and a
`flags` block. Pass `ai_only: true` for the AI Register view. Read it first, and ask the
user only about what it doesn't hold.

A register that looks short is usually a finding in itself. If the organisation plainly
uses tools that aren't recorded (the ones you can see connected in this session are a good
first check), say so before reviewing what is there.

## Read the flags in this order

1. **`risks`**, highest severity first. `employee_contracted` is the one that matters most:
   a personal plan used for work means no DPA, no admin control and no audit trail. That is
   shadow AI, and it is the headline. `trains_on_data` without `dpa_in_place` comes next.
   `prohibited_in_use` means a tool the organisation banned is still held.
2. **`unreviewed`** — arrangements nobody has made a decision on. Unreviewed is not
   approved. Count them and say so.
3. **`ai_without_arrangement`** — AI the organisation uses with no record of how it holds
   it. Each one is a question: who pays, on what plan, under what terms?
4. **`not_in_model`** — systems in the register that no process step runs on. Either the
   work that uses them hasn't been mapped, or it's shelfware. Both are worth saying.
5. **`renewals_due`** (admins and core team only) — renewals in the next 90 days. Pair each
   with its risks and its usage: a renewal is the moment to fix an arrangement, and a tool
   used in no step is a candidate not to renew.

**A null is "not assessed", never "no".** `dpa_in_place: null` means nobody has checked,
which is different from `false`. Report unassessed fields as gaps to fill, not as passes.

## What's been built and switched on

The systems register says which products the organisation holds. **`kowalah_get_ai_estate`**
says what's deployed inside them: connectors, skills, plugins, projects, agents, automations
and apps, who uses each, and the process steps they run. Read its `gaps` first:

- **`unsanctioned`** — assets on a platform the organisation hasn't approved or has
  prohibited, personal ones first. This is the shadow-AI list, and it joins the two
  registers: a personal Gmail connector on an unreviewed Claude plan is one line here.
- **`personal`** — one person's own tools used for work, with their platform's standing.
- **`undecided`**, **`no_owner`**, **`scope_unknown`** — what nobody has decided. Admins and
  core team settle these with `kowalah_record_ai_assets` (by `id`: owner, status, scope).
- **`not_in_model`** — agents, skills, automations and apps that run no process step. Either
  the step hasn't been mapped or the tool isn't earning its keep.
- **`needs_auth`** — connectors installed but never connected, or disconnected.
- **`stale`** — nobody has shared it from their session for 90 days: likely retired.
- **`suggested_step_links`** — steps whose text names an agent, skill, automation or app
  that isn't linked to them yet ("Brian drafts the reply"). Confirm each with the process
  owner, then link it with `kowalah_record_ai_assets` (`id` plus `serves_step_ids`). This is
  the quickest way to turn the free-text model into one that knows what runs each step.
- **`platform_unknown`** — assets with no platform, so the shadow-AI check can't see them.
  Usually the platform isn't in the systems register yet: add it with `kowalah_save_system`,
  and the next `my-ai-tools` run links everything on it.
- **`reaches_unregistered`** — connectors to a system the register doesn't hold (Figma,
  Sentry). Add the system if the organisation depends on it.
- **`acts_unsupervised`** — connectors that `can_act` (send, edit, delete) with no human
  approving. This is the one to read out first after shadow AI: ask whether anyone signs
  off on what it does, and record the answer as `human_approval`.
- **`connection_concentration`** — one person's login holds three or more of the
  organisation's connectors. If they leave or their account is locked, all of them stop at
  once. Admins and core team see who; members see only counts.
- **`in_house`** — what the organisation built itself. Nobody outside maintains these, so
  each needs a named owner and a `maintained_at` home (a repo or a folder).

Each asset also shows its `origin` (anthropic, kowalah, vendor, in_house, unknown), its
`version` and where it's `maintained_at`. Sessions fill these in when they can see them.
How each is held is a decision, set by admins and core team with
`kowalah_record_ai_assets`:
- `connection_holder_user_id`: whose login the connector runs on. A member can say their
  own connector runs on their own login.
- `access_level`: `read_only` or `can_act`
- `human_approval`

Leave any of these unset rather than guessing. An unknown access level is a gap, not
read-only.

Each asset shows its `platform` and, for a connector, the systems it `reaches`. Pass
`unit_id` to see one part of the business, or `origin` to see, say, only what was built in
house.

**What each tool has delivered.** Every asset carries an `outcomes` count, and `id` returns
the outcomes themselves with totals. An agent that runs live steps and has no outcomes
hasn't been shown to earn its keep: before a renewal or a retirement, ask its owner what it
has delivered, and record it with the `outcomes` skill.

**Assets no Claude session can see** — agents on the Agent Hub or the Claude API, Zapier or
n8n automations, Copilot agents, Slack bots — are added by hand: `kowalah_record_ai_assets`
with `source: "manual"`, the kind (usually `agent` or `automation`), and the `system_id` of
the platform it runs on. Then link the steps it runs.

**The register is only as complete as the people who have shared their tools.** It is
filled by the `my-ai-tools` skill, which each person runs in their own Claude: it shows them
their setup, fixes what's half connected, and records what they choose to share. There is
no background collection. If the register is thin, or `stale` is long, the fix is to ask the
team to run `my-ai-tools` (a one-line message from the AI lead is usually enough), not to
fill the register by guessing. If it's complete but nobody has said what things are for,
ask the owners of the live, organisation-wide tools to run its part two.

## Where each tool is used

`kowalah_get_systems` with an `id` returns `used_in`: every live step and process that runs
through that system. This is what makes the register more than a list: "Claude is used in
12 steps across 4 processes" tells the reader what a problem with Claude would touch. Use it
when a risk is serious, before a renewal, and whenever someone asks what a tool is for.

When a step runs on a tool but the step doesn't say so (the tool is named only in
`platform_detail`, or not at all), set `system_ids` on `kowalah_save_process_step`. It
replaces the whole set, so pass every system the step uses.

## Keeping the register true

**`kowalah_save_system`** adds or updates a system and its arrangements. Admins and core
team only; for anyone else, read the register and offer `kowalah_create_opportunity` for
the change.

- Search before adding (`kowalah_get_systems` with `search`). Saving a name that's already
  in the register returns the existing system rather than a duplicate, and a name in
  Kowalah's catalogue uses the catalogue system: record the organisation's arrangements on
  it. Only pass `own_copy: true` when the organisation needs its own record, for example to
  mark a catalogue CRM as having `embedded` AI switched on.
- **One system, several arrangements.** "Claude Team, 50 seats, organisation-contracted,
  DPA in place, approved" and "Personal Max plans, employee-contracted, unreviewed" are two
  arrangements on one system. Don't create a second system for the second way of holding
  it.
- **`ai_capability`** is a spectrum, not a yes/no: `embedded` for AI switched on inside a
  non-AI product (Slack AI, HubSpot Breeze), `native` when the product is AI (Claude,
  ChatGPT), `infrastructure` for model or API access (Claude API, Azure OpenAI). `embedded`
  is the category people forget, and it is often the largest.
- Record only what the user actually knows. Leave the rest unset rather than guessing, and
  never set `sanctioned_status` to approved on the user's behalf: only the organisation can
  approve a tool.
- Retire a tool with `status: "archived"`; systems are not deleted.

## What a good review says

1. **What the organisation has** — the count of AI systems and how they're held, what has
   been built in them, and what's plainly missing from either register.
2. **What to worry about** — the risks, named, with where each tool is used; what acts
   with nobody approving; whose single login everything depends on.
3. **What nobody has decided** — the unreviewed arrangements and the unassessed fields.
4. **The next decision** — usually a renewal, a tool to approve or retire, or a register to
   complete. Name who has to decide.

## Scope and permissions

Everyone in the organisation can read the register. Cost, payment route and renewal dates
are shown to admins and core team only; the response's `commercial_fields` says which you
got. If they're hidden, say so rather than implying the organisation has no costs recorded.

If the user belongs to more than one Kowalah organisation, pass `organization_id`. Call
`kowalah_get_update` with no query to list their organisations, then ask which one.
