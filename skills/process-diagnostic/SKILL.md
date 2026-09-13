---
name: process-diagnostic
description: Read one business process honestly — where its cycle time actually goes, how many handoffs it has, and what has never been measured. Use for "walk me through this process", "why does this take so long", "where are the bottlenecks in X", or before proposing any change to a process.
---

# Process diagnostic

For the person who owns a process and has to decide what to do about it. This is the read
that comes before any redesign. Run it first — `process-redesign` assumes it.

## Read the model before you ask

The operating model already holds the owners, the steps, the timings, the constraints, the
quality bars and the work in flight. **Ask the user only for what it doesn't have.**
Questioning someone about a process the model already describes wastes their time and
tells them you didn't look.

Where the model is missing something, that absence is usually the finding — say what isn't
recorded rather than quietly filling the gap from conversation.

## Sequence

1. **`kowalah_get_process`** with the process UUID. If you do not have the UUID, get it
   from `kowalah_get_operating_model_unit` (the unit's process list) or
   `kowalah_get_update`.
2. **Read the `diagnosis` block first** — before the steps, before the roll-up. It is the
   derived read of how well the process is actually captured, and it decides whether the
   rest of the data can be trusted.
3. **Check `access`** before offering to change anything.
4. Narrate the chain: steps in order, current→target dispositions, gap and constraint
   markers, the DEFINE contract on each step, and the ranked `backlog`.

## The counting rule that governs everything

**A null is "can't say". It is never "none".**

This is the single most important thing to get right, and the easiest to get wrong, because
a null renders as an absence and an absence reads as a clean bill of health.

- `handoff_count` is null whenever *any* step lacks an owner. A partial count would
  understate the handoffs — and the handoffs are where the waiting is. When it is null,
  say so and ask for the missing owners. Do not describe the process as though it flowed
  straight through.
- `cycle.ratio` is null unless *every* step is both timed and costed. A ratio built from
  three of twelve steps makes a process look tighter than it is.
- `touch_minutes_total` is a **floor**, not a total. Read it alongside
  `steps_missing_touch`. "At least 40 minutes, across the eight steps anyone has timed" is
  honest; "40 minutes" is not.

## Work is measured in minutes. Processes are measured in days.

`cycle.ratio` is touch time over elapsed time across the whole chain. **When it is there,
lead with it.**

A process that is 0.4% work and 99.6% waiting cannot be fixed by making the work faster.
That is usually the entire finding, and it reframes the conversation from "can AI do this
step quicker" to "why does this sit for six days between steps". Automating a step inside a
process that is 99% waiting moves nothing.

**When `cycle.ratio` is null, the missing timings are the finding.** Do not skip past it to
the parts you can measure. `cycle.steps_untimed` gives you the sentence: *"nine of twelve
steps have never been timed end to end — we cannot say where this process spends its
time, and that is the first thing to fix."* That is a more useful output than a confident
read of the three steps that happen to have data.

## The rest of the diagnosis block

- `constraint_steps` — steps marked as constraining the whole chain. These rank highest in
  the redesign backlog and are where effort actually pays.
- `steps_missing_output` and `steps_missing_acceptance_criteria` — the DEFINE contract
  gaps. A step with no defined output artifact or no acceptance criteria cannot be handed
  to AI, because there is no bar to hold it to. Route these to `quality-bar`.
- `steps_with_exception_notes` — where the documented process and the real one diverge.
  Worth reading aloud; exception notes are usually where the actual work happens.
- `chased_steps` — steps that need chasing. Chasing is coordination burden, and it is
  invisible in touch time.

## Use it to challenge, not just to report

The diagnosis is a set of questions to put to the owner, not a summary to read back. Good
challenges:

- "Four different people own steps in this chain. What happens between step 3 and step 4?"
- "Six of these steps have no acceptance criteria. How does anyone know when they're done
  right?"
- "The constraint is step 7, but the two initiatives aimed at this process both target
  step 2."
- "This is 12 minutes of work spread across 9 days. What are we actually trying to fix?"

## Before offering to change anything

`access` reports what this user may do to this process: `relationship`
(`at_own` / `below` / `at_peer` / `above` / `lateral`), `can_edit`, `can_create`,
`can_propose`.

**When `can_edit` is false, the route is `kowalah_propose_process_change`, not an edit that
will be refused.** Say which route you are taking and why — "this process is owned by
Operations, so I'll file this as a proposal for its owner rather than editing it" is a
useful sentence, not an apology.

`initiatives` lists the opportunities, deliverables and projects already aimed at this
process, pinned to a step where relevant. It is filtered to what this user may personally
see, so it can legitimately differ between colleagues — do not present it as the complete
list of work on this process.

## Where to go next

- The process needs restructuring, not just better paint → `process-redesign`
- Steps lack acceptance criteria or quality checks → `quality-bar`
- Something needs to go to the Kowalah team → `raise-opportunity`
