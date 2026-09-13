---
name: process-redesign
description: Take a process from as-is to a proposed to-be — mark up what gets eliminated, merged or kept, then generate the redesign beside the original so the two can be compared. Use for "redesign this process", "how would we do this with AI", "these ten steps should be three", or when a diagnostic shows the process needs restructuring rather than automating.
---

# Process redesign

For a process owner who has diagnosed a process and concluded it needs restructuring. Run
`process-diagnostic` first — this skill assumes you have the diagnosis and have checked
`access`.

## Read the model before you ask

The operating model already holds the owners, the steps, the timings, the constraints, the
quality bars and the work in flight. **Ask the user only for what it doesn't have.**
Questioning someone about a process the model already describes wastes their time and
tells them you didn't look.

Where the model is missing something, that absence is usually the finding — say what isn't
recorded rather than quietly filling the gap from conversation.

## Why this is not a disposition change

A step's disposition — `human`, `ai_assisted`, `automated`, `ai_autonomous` — says **who
runs the step**. Every one of those values *keeps the step*.

Editing dispositions can only ever produce the same process with better paint. If the
answer is "these ten steps become three", no amount of disposition editing gets you there.
`kowalah_propose_redesign` is the tool that can.

So the first question is always: **is this a redesign, or is this automation?** If the
shape of the chain is right and individual steps should be run differently, use
`kowalah_save_process_step` to set target dispositions and stop. If the chain itself is
wrong, continue here.

## The order matters

**Mark up the real process first. Generate the redesign second.**

`kowalah_propose_redesign` *seeds* the to-be from the as-is and from the redesign decisions
already recorded on the steps. Call it before doing the thinking and you get a copy you
then have to prune by hand. Do the thinking first and you get a redesign that already
reflects it.

### 1. Mark each step

`kowalah_save_process_step` with the step `id`, setting `redesign_decision` and
`redesign_rationale`.

- Steps marked **`eliminate`** or **`merge`** do not carry across.
- Everything else carries.
- **A step with no decision is CARRIED, and reported back in `undecided_count`.** Silently
  dropping work nobody decided to drop would be the worst possible default — so an
  unmarked step survives. The count is your check that you covered the chain.

Always write `redesign_rationale`. The decision is what happens; the rationale is what
someone six weeks from now needs in order to argue with it. "Eliminate — this approval only
existed because the previous system couldn't enforce the limit" is defensible. "Eliminate"
alone is not.

Work through the chain in order and put a decision on every step, including the ones you
are keeping. An explicit "keep" and an unmarked step produce the same to-be but a very
different review.

### 2. Generate the to-be

`kowalah_propose_redesign` with the as-is `process_id`.

You get back a real process — status `draft`, `redesign_status` `proposed`, its own process
number — with `step_count`, `carried_count`, `dropped_count` and `undecided_count`.
**Nothing about the as-is changes.**

Check `undecided_count` immediately. If it is not zero, name the steps that carried without
a decision and ask whether that was intended.

## Two things are deliberately cleared on the to-be

Both are easy to read as bugs. Neither is.

**Target disposition is cleared.** The redesign is a new design question. Inheriting the
old target would pre-answer it — you would be deciding how to run step 4 of the new process
based on a judgement made about step 4 of a process that no longer exists.

**Elapsed time is cleared.** It is the number the redesign exists to *move*. Carrying it
over would make the comparison show a saving of zero until somebody noticed. The to-be
needs its own estimates, and putting them in is part of the design work — not an
afterthought.

Say both of these out loud when you present the redesign, or the first question you get
will be "why is the target column empty".

## Competing options are allowed and usually better

Call `kowalah_propose_redesign` twice and you get option A beside option B, both held
against the same as-is. This is often the right move: a conservative redesign and an
aggressive one, priced separately, lets the owner make a real decision instead of
approving or rejecting a single proposal.

To do this, set one pass of decisions, generate option A, then revise the decisions on the
as-is and generate option B. Name them clearly in the rationale so the two can be told
apart later.

## Presenting the comparison

Lead with the mechanism, not the count. "Ten steps to three" is a headline; *why* is the
argument:

- Which steps were eliminated and what made them unnecessary
- Which were merged and what handoff that removes
- What the constraint step becomes
- What the elapsed-time claim rests on — and flag it as an estimate, because the to-be's
  timings are exactly that until the process runs

If the as-is diagnosis had a `cycle.ratio`, frame the redesign against it. A redesign that
cuts touch time in a process that was 99% waiting has not fixed the problem, and it is
better to say that before someone else does.

## Permissions

Redesigning follows the same rule as editing: you may redesign a process you own or one at
or below your unit. Admins and core team may do it anywhere in the organisation.

Check the `access` block on `kowalah_get_process` first. **When `can_edit` is false, the
route is `kowalah_propose_process_change`** — it files an opportunity against the process
(optionally pinned to one step) so the owner can pick it up. Nothing about the process
changes. Anyone may propose against any process they can see, so this route is always open.
