---
name: quality-bar
description: Define what "good" means for a process step and set the checks that hold it there — acceptance criteria, gates and monitors, target scores. Use for "how do we know the AI is doing this right", "set up evals for this step", "what counts as a good output here", or before handing any step to AI.
---

# Quality bar

For a process owner who is about to let AI run part of a process, or who already has and
cannot say whether it is working. This is where a business owner sets the bar in their own
terms — *"what counts as a good forecast category call"*, *"what a compliant response looks
like"* — rather than delegating it to whoever builds the thing.

## Read the model before you ask

The operating model already holds the owners, the steps, the timings, the constraints, the
quality bars and the work in flight. **Ask the user only for what it doesn't have.**
Questioning someone about a process the model already describes wastes their time and
tells them you didn't look.

Where the model is missing something, that absence is usually the finding — say what isn't
recorded rather than quietly filling the gap from conversation.

## The rule this enforces

**A step with no acceptance criteria cannot be handed to AI, because there is no bar to
hold it to.** Not "should not" — cannot, meaningfully. You can wire it up, but you will
have no way to say whether it works, and no way to notice when it stops.

`kowalah_get_process` reports `steps_missing_acceptance_criteria` and
`steps_missing_output` in its `diagnosis` block. Those two counts are the backlog this
skill works through.

## Sequence

1. **`kowalah_get_process`** — read the steps, their DEFINE contract
   (`acceptance_criteria`, `input_artifact`, `output_artifact`), and any evals already
   attached. Check `access`.
2. **Fix the contract first** with `kowalah_save_process_step`. A step needs a defined
   `output_artifact` before an acceptance criterion means anything — you cannot say what
   good looks like until you have said what the thing *is*.
3. **Then attach evals** with `kowalah_save_process_step_eval`.

Doing 3 before 2 produces evals that check something nobody has defined.

## Writing acceptance criteria that work

The test of a criterion: **could two people independently apply it and agree?**

- *"The response is accurate and helpful"* — fails. Nothing to disagree with, nothing to
  check.
- *"Every figure quoted traces to a row in the source ledger, and no figure appears that
  isn't in it"* — passes. Checkable by anyone, and it names the failure mode that actually
  happens.

Write criteria against the **failure you are afraid of**, not the success you are hoping
for. Ask the owner: what would a bad output look like, and who would be harmed by it? That
question produces better criteria than "what does good look like" in about nine cases out
of ten.

## Gate or monitor

`mode` is the decision that matters most, and it is a business decision, not a technical
one.

- **`gate`** — blocks the step until it passes. All-or-nothing. It **must not** carry a
  `sampling_pct`; setting one is rejected, because a gate that only checks 20% of cases is
  not a gate.
- **`monitor`** — observes a sample and reports. May set `sampling_pct` (0–100).

Choose a gate when a single bad output is unacceptable — a payment released, a regulated
communication sent, a customer commitment made. Choose a monitor when you need to know the
error rate but individual errors are recoverable.

Most steps want both: a narrow gate on the thing that must never go wrong, plus a monitor
on overall quality. They are separate eval rows on the same step.

## The other eval fields

- **`method`** — `human_review` (default) | `llm_judge` | `programmatic` | `golden_set`.
  Start at `human_review` unless there is a reason not to; a human-reviewed eval that
  actually runs beats an automated one nobody built. `golden_set` is the strongest option
  where you have a set of known-correct cases to hold against.
- **`criteria`** — free text, what "pass" means. This is where the owner's own words go.
- **`target_score`** — the bar. **`current_score`** — the latest reading. Setting
  `current_score` stamps the measurement time automatically; clearing it clears the stamp.
  You cannot set the timestamp, the source, or the position — the server owns all three.
  **Read that stamp back and check its age.** A `current_score` measured eleven months ago
  is not a current score, and reporting it as one is how a step drifts for a year while the
  dashboard says it's passing. Quote the reading with its date, or say plainly that nobody
  has measured this since.
- **`status`** — `defined` (default) | `active` | `retired`. An eval sitting at `defined`
  is a written intention, not a running check. Be precise about the difference when
  reporting: "we have defined four evals and none are active" is the honest version.
- **`owner_user_id`** — the eval's owner on the client side. This matters: **once created,
  the eval's owner may edit it thereafter even if the process itself sits above their
  altitude.** So a function lead can own the quality bar on a process they do not otherwise
  control. Set it deliberately.

## Jidoka: autonomous steps need a stop-condition

When a step's effective `target_disposition` is **`ai_autonomous`**, an
`escalation_trigger` is **required** — the condition that returns control to a human. A
partial update that would leave the step autonomous without a trigger is rejected.

This is not a form field to fill in. Ask the owner directly: *what has to happen for a
person to be pulled back in?* Good triggers are specific and observable — a confidence
threshold, a value above a limit, a case type, an eval failing. "If something goes wrong"
is not a trigger.

If the owner cannot name one, that is a strong signal the step is not ready to be
autonomous. Say so, and set the target to `ai_assisted` instead.

## Permissions

Creating an eval needs edit rights on the parent process. If `access.can_edit` is false,
route through `kowalah_propose_process_change` — a proposal to add a quality gate is
exactly what that tool is for.

Once an eval exists, its `owner_user_id` may edit it regardless of process altitude. Admins
and core team may do either anywhere in the organisation.
