---
name: raise-opportunity
description: Take an idea or an ask to the Kowalah team properly — check what already exists, test it against the AI vision, score it, and submit it. Use for "I need help with", "raise this with Kowalah", "we should look into", "I've got an idea about", or when a review turns up a gap somebody wants to act on.
---

# Raise an opportunity

`kowalah_create_opportunity` is the single entry point for everything a client might want
help with — a quick question, a piece of work for the Kowalah team, a new initiative, a
project to scope. **The user does not need to decide in advance which it is.** They
describe what they are trying to do; Kowalah triages from there. Anyone in the organisation
can raise one, at any role.

This skill is the four things to do before submitting. Skipping them is how thin,
unscoreable opportunities end up in the queue.

## Read the model before you ask

The operating model already holds the owners, the steps, the timings, the constraints, the
quality bars and the work in flight. **Ask the user only for what it doesn't have.**
Questioning someone about a process the model already describes wastes their time and
tells them you didn't look.

Where the model is missing something, that absence is usually the finding — say what isn't
recorded rather than quietly filling the gap from conversation.

## 1. Check the library first

**`kowalah_find_accelerator`** before anything else. The library holds pre-built prompts,
GPTs, training and tools — the organisation's own private accelerators plus Kowalah's
global library, each result tagged with a `scope` of `org_private` or `global`.

Results often carry a try-it-now prompt the user can act on immediately. **If there is a
match, the right outcome is the user using it today — not an opportunity raised for
something that already exists.** Say what you found, offer it, and only continue if it
genuinely does not fit.

Search on the problem, not the solution. Someone asking for "an AI tool to summarise
supplier contracts" should be searched as "contract review" and "supplier" separately —
the useful match is rarely phrased the way the ask is.

## 2. Get the description to something real

The server enforces a minimum length, but the bar that matters is higher than the one it
checks. A one-line opportunity wastes everyone's time and is slower to triage.

If the first message is thin, ask:

- What is the goal — what changes if this works?
- What would good look like?
- What context should Kowalah know that isn't obvious? Systems, constraints, who is
  involved, what has already been tried.

Write it up as a paragraph or more. Keep the user's own words for the goal; they are
usually more precise than a tidied-up version.

## 3. Test it against the vision

If the organisation has a vision map — the `vision` block on
`kowalah_get_operating_model`, or `kowalah_get_vision` — **name in the `content` which
guiding principle this serves and which KPI it moves.**

Several clients make this their own programme success measure: *every use case names the
KPI it moves before it starts.* This tool is where that gets enforced, so do it properly.

Each principle carries its defining attributes as an assertion plus a counter-clause — *"It
moves a business KPI." / "Not a good idea in search of one."* **Apply both halves.** The
counter-clause is the useful one; it is what lets you tell the user their idea is a good
idea in search of a problem without it being your opinion.

**If it does not obviously serve any principle, say so to the user before submitting. That
is a real signal, not a blocker.** Plenty of worthwhile work sits outside the current
vision, and surfacing the mismatch is more useful than quietly forcing a fit.

If `lastUpdatedAt` shows the vision map is well over a year old, note that alongside the
mismatch. "This doesn't fit the vision, but the vision hasn't been revisited since last
March" is a fairer thing to put in front of a triage team than either half alone.

Skip this step entirely when no vision map exists.

## 4. Score it

ICE — impact, confidence, ease, each 1–10, with a short rationale for each. Technically
optional in the schema; **expected in practice.** Unscored opportunities are slower to
triage and give the team nothing to weigh them against. Skip only if the user explicitly
declines.

For `impact`, use the slot that fits — the point is a number the business recognises:

- **business** — *"£2M annual cost reduction in supplier spend"*
- **productivity** — *"200 hours/week saved across support"*
- **adoption** — *"drive ChatGPT login rate from 15% to 60%"*

The composite is computed server-side. Partial scores are accepted, but push for all three
numbers plus a rationale each. Do not invent the numbers — ask. "What would this be worth
if it worked?" is a question the user can usually answer, and their answer is better than
your estimate.

## Before you call the tool

- **Which organisation?** `organization_id` is required. If the user belongs to more than
  one, ask — do not guess. `kowalah_get_update` with no query lists their organisations.
- **Is this a response to a Kowalah discovery?** Check `pending_discoveries` in the
  `kowalah_get_update` home view. If it is, pass that `discovery_id` — it links the
  response to the brief, stamps the opportunity with the discovery and its project, and
  marks the audience invite responded. Anchor the impact rationale to the discovery's
  `business_value_context`.
- **Is it about a process the user cannot edit?** Then the right tool is
  `kowalah_propose_process_change`, not this one — it files the opportunity against the
  process (optionally pinned to one step) so the owner can pick it up.
- **Optional but useful:** `department`, `source_note` (*"raised at yesterday's leadership
  meeting"*), `requested_project_id`.
- **`requested_target_type`** — `deliverable` or `expert_request` — only if the user has a
  strong view on the form of help. **Omit it if they are unsure.** Guessing here pre-empts
  a decision Kowalah makes together with the client, and a wrong guess is worse than no
  guess.

## After

**Tell the user the opportunity number.** It is how they refer back to it — `kowalah_get_update`
with that number brings up its status. The response also returns their recent opportunities,
so they can see their queue; worth showing if they have several in flight.
