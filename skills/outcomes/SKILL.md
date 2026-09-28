---
name: outcomes
description: Record and report the value AI has actually delivered — time saved, cost reduced, revenue won, adoption milestones — on any work (a process step, a process, a unit, an opportunity, the whole organisation, a Kowalah deliverable), with what produced it and which vision measure it counts towards. Use for "we're saving 5 hours a week on this", "log that win", "what value have we got from AI", "what has this agent delivered", "how are we tracking against our success measures", or verifying a claimed outcome.
---

# Outcomes

An outcome is value that has actually happened, not value a use case is expected to
deliver. Expected value belongs on the opportunity's ICE score. This skill records the real
thing when someone reports it, and reports what's been realised when someone asks.

The reader who matters is whoever has to stand behind the number: the AI lead reporting to
the board, or the sponsor deciding whether to fund the next phase. So record in a way that
survives their questions.

## Recording one

**`kowalah_save_outcome`** records an outcome. Anyone in the organisation can record one.

**Put it on the work it happened in.** `on` is what the value is on:
- `process_step`: "Koko's triage saves two hours a month" is on the triage step. This is the
  most useful place, because the process then shows what it has delivered.
- `process`, `org_unit` or `opportunity` when the value is wider than one step.
- `organization` only for organisation-wide milestones ("80% of staff active weekly").
- `deliverable` or `expert_request` for value from a piece of Kowalah's work.

Find the id first: `kowalah_get_process` for steps, `kowalah_get_operating_model` for
units. Members can only record on a deliverable or expert request they're a stakeholder on.

**Link what produced it and what it counts towards.** If an agent, skill or automation
delivered the value, set `ai_asset_id` (from `kowalah_get_ai_estate`). That's how the estate
can say which tools are earning their keep. If it moves one of the vision's success
measures, set `vision_measure_id` (from `kowalah_get_vision`).

**Ask for a figure, and make it comparable.** With a number, always set:
- `value_unit`: hours, count, percent or currency
- `currency` for money, in any ISO currency: record euros as EUR, not converted
- `period`: `one_off`, or how often it recurs

Without these, the outcome is counted but can't be added up. "Saves two hours a month" is
`value: 2, value_unit: hours, period: monthly`. With no figure at all, still record it: a
milestone with a good narrative is an outcome.

**Ask how they know, and record the answer as `basis`.**
- `estimated`: a judgement
- `sampled`: timed on a few cases
- `measured`: from a system

Don't upgrade a guess. "About five hours, I reckon" is `estimated`, however confident the
user sounds. An honest estimate is worth more than a measurement nobody can reproduce. Put
the evidence in `evidence_url` if there is some.

**Write the narrative in their words:** what changed, for whom, and how they know. One
paragraph is plenty. `source` is `client` for the organisation's own work (the default),
`kowalah` for Kowalah's, and `joint` for both.

## Claimed and verified

Every outcome starts as a **claim**. Admins and core team can **verify** one (`verify:
true`), and it's recorded in their name. That's the organisation standing behind the
number. Anyone else who wants a claim verified should ask an admin or core team member.

- Changing a verified figure (value, unit, period, basis, or what it's on) makes it a claim
  again, and the tool says so. Tell the user it needs verifying again.
- Only the person who recorded an outcome, or an admin or core team member, can edit or
  remove it. Removing keeps it in history. Give a `reason`.
- Never verify on someone's behalf, and never describe a claim as verified.

## Reporting what's been realised

- **One process:** `kowalah_get_process` returns `outcomes` for the process and its steps.
- **One tool:** `kowalah_get_ai_estate` shows each asset's outcome count. With an `id`, it
  returns the full list.
- **Against the vision:** `kowalah_get_vision` returns each success measure with its
  baseline, target, current reading and `progress`.

**Read `totals` by unit, and keep what they keep apart:**
- **Claimed and verified.** Lead with verified. Then say how much more is claimed but
  unverified.
- **Recurring and one-off.** `recurringPerYear` is recurring value annualised. `oneOff` is
  one-off value. Adding them together gives a number that means nothing.
- **Different units.** Hours, pounds and euros are separate lines, never converted or
  summed.
- **`notComparable`.** These outcomes have no unit or period. Count them, say they couldn't
  be added up, and offer to fill in the figure.

**Say the basis.** "About 400 hours a year, mostly estimated" is honest. "400 hours a year"
over a set of guesses is not. If most of the value is estimated, the next step is usually
to sample one step properly.

**A missing outcome is a finding, not a zero.** An agent that runs three live steps and has
no outcomes hasn't been shown to be worthless: nobody has recorded what it does. Ask its
owner. The same goes for a vision measure with no current reading: say it hasn't been read,
not that nothing has moved.

## What a good report says

1. **What's verified**, by unit, with what produced it.
2. **What's claimed on top**, and its basis.
3. **What should have an outcome and doesn't:** live AI with nothing recorded, measures with
   no current reading.
4. **The next step:** usually someone to verify, a step to sample, or an owner to ask.

If the user belongs to more than one Kowalah organisation, pass `organization_id`.
