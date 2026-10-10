# Scheduled task ideas

Each idea says who it usually suits, a sensible timing, and a prompt template. Fill in
the parts in [square brackets] for the person, and adapt the wording to what they asked
for. Suggestions, not a menu to read out: pick the two or three that fit.

| Idea | Kind | Usually suits | Timing |
|---|---|---|---|
| What's new for me | Tells them something | Anyone | Weekly, Monday morning |
| The week in my area | Tells them something | Process owners | Weekly |
| Progress against our vision | Tells them something | AI programme leads, executive sponsors | Monthly |
| Draft my programme update | Drafts something | AI programme leads | Weekly, before the steering meeting |
| Ideas from my week | Drafts something | Anyone who wants it | Weekly, Friday |

---

## What's new for me

New accelerators in their library that are relevant to them, so they hear about
something useful when it's added rather than when they happen to search.

> Every [Monday at 08:30], check what's new for me in Kowalah for [organisation].
> Call `kowalah_get_update` with `since` set to the date this task last ran (on the first
> run, seven days ago). From the accelerators it returns, pick the ones most relevant to
> [my role / the [unit] team / the processes I work on], and for each give its name, one
> line on what it's for, and how to open it. Mention how many others were added. Report
> only what the answer's `covers` list includes. If nothing is new, reply with one line
> saying so.

## The week in my area

What moved in the person's own unit: open questions to answer, the redesign backlog and
how far each process has got.

> Every [Monday at 09:00], give me the week in [unit] at [organisation]. Call
> `kowalah_get_operating_model` with `view: "rows"` and use the rows for [unit] and the
> units beneath it. Tell me: the open questions on my processes, newest first, with the
> process and step; the top items in the redesign backlog for my area; and, from each
> process's `readiness`, what's furthest behind. Use the wording in `definitions` for
> every figure. Describe steps, never named people. Finish with the one thing most worth
> doing this week. Keep it to a screen.

## Progress against our vision

How the organisation is tracking against the measures it set in its vision: baseline,
target, where it is now and how old each reading is.

> On the [first Monday of each month], report [organisation]'s progress against its
> AI vision. Call `kowalah_get_operating_model` with `view: "rows"` and read `vision`.
> For each measure, give the baseline, target, target date, the current reading and when
> it was taken, and `progress`. Flag any measure with no current reading or a reading more
> than [three months] old: unmeasured is not the same as not moving. Then, from the rows,
> say where the business is most constrained. If there is no vision map, say so in one
> line.

## Draft my programme update

A first draft of the regular programme update, ready to edit, so it isn't built from
scratch each week.

> Every [Friday at 14:00], draft my programme update for [organisation]'s [steering
> group]. Use the programme-views skill to build a [doc] for [the steering group]:
> decisions needed first, then where the business is constrained and what's aimed at it,
> what changed since the last update, progress against the vision, and what isn't known
> yet. Lead with constraints, not coverage. Show the source and date of every figure. This
> is a draft for me to review: don't share it or send it to anyone.

## Ideas from my week

Looks at the person's own week, in the tools they choose, for recurring work and friction
that might be worth improving, and suggests what to do about it.

Only suggest this when the person has a calendar, email or document store connected and
wants it used. Agree with them which sources it may look at.

> Every [Friday at 16:00], look at my week in [calendar / documents / the sources I've
> agreed] and suggest up to three pieces of recurring work or friction that might be
> worth improving. Leave out anything personal. For each, say what you noticed, which
> process in [organisation]'s operating model it seems to belong to (check with
> `kowalah_get_operating_model`, `view: "rows"`), and whether it looks like a step to
> add, a change to an existing step, or an opportunity to raise. Describe the work, never
> other people. Don't save, propose or raise anything: list the suggestions for me, and I'll
> decide in a normal conversation what to take further.
