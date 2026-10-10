# Data for programme views

## The backbone: one call

**`kowalah_get_operating_model` with `view: "rows"`** returns the whole operating model for
the organisation in one call, as flat lists that need no reshaping:

| List | One row per | Carries |
|---|---|---|
| `rows.units` | Org unit, in tree order | `path`, `depth`, `parentName`, `leaderName`, and the unit's roll-up across everything beneath it: `coveragePct`, `processCount`, `gapCount`, `constraintCount` |
| `rows.processes` | Live process | `processNumber`, `unitName`, owner names, a `rollup`, `openQuestionCount`, and `readiness` |
| `rows.backlog` | Redesign gap, ranked | `rank`, `processNumber`, `processName`, `unitName`, `stepName`, `reason`, pricing and hours |
| `rows.openQuestions` | Unanswered question, newest first | `processNumber`, `stepName`, `unitName`, `body` |
| `rows.totals` | The organisation | The same roll-up figures across all of it |
| `rows.counts` | — | How many backlog items and open questions exist, against how many came back |

Pass `backlog_limit` and `question_limit` (up to 500) when the view needs more than the
default 50. Use `counts` to say when a list was cut.

**`readiness`** on each process says how far it has got: whether an owner is named, how
many steps have touch time and how many have elapsed time (`fullyTimed` when every step
does), how many steps carry a redesign decision (`redesignMarkedUp`), whether a to-be
redesign has been proposed, and how many steps are linked to an AI tool. It is the
quickest way to show a pipeline from "mapped" to "redesigned".

**`definitions`** comes with every answer: one line per figure. Label figures with it.

**`vision`** holds the organisation's vision measures, where a vision map exists: the
measure in the organisation's own words, the baseline, the target, the target date, the
current reading if one has been taken, and `progress`. It is null when there is no vision
map; say so rather than inventing a target. For the vision statement and principles
themselves, call `kowalah_get_vision`.

If the connector doesn't accept `view: "rows"`, it is an older version. Use
`kowalah_get_operating_model` for the tree and `kowalah_get_operating_model_unit` for each
unit that matters, and tell the person the build will take longer.

## Going deeper

- **One process in full:** `kowalah_get_process`, for a view built around a single process.
  Its `diagnosis` says how well the process is captured, and where the time goes.
- **Work in flight:** `kowalah_get_update` with no query lists projects, deliverables and
  opportunities. Use it to show whether the work in flight is aimed at the constraints.
  Members see a partial portfolio by design, so say so on the page if the person is a
  member.
- **Value delivered:** recorded outcomes. See the `outcomes` skill for how to read and
  report them honestly.

## What isn't available

Say these out loud when the view would naturally show them. Don't approximate them.

- **Value rolled up by process across the organisation.** Outcomes can be read where they
  were recorded, but there is no single organisation-wide roll-up of value by process yet.
- **How much AI tools are used, by team.** The operating model holds what's been mapped and
  changed, not usage figures. If the person has a usage source connected, offer it.
- **How often a tool or skill has been reused.** Not tracked.
- **Group-wide effort across every deployment of a process.** Reported as null, which means
  "not reported", never zero.

## Checking figures before they go out

- A unit with no processes shows no constraints because nobody has looked, not because
  there are none. Show that it is unmapped.
- A null is "can't say", never "none". Don't turn a null into a zero on a chart.
- If coverage rose and constraints did not fall, the view should make that visible.
