# Dashboard

For a view people come back to. Best when the figures change week to week and the reader
wants to look things up rather than be walked through them.

**If your assistant offers a dashboard template** (in Claude, the Dashboard template,
where the plan and admin settings allow), start from it. Where the reader's assistant can
reach the same connectors, a dashboard can read the operating model live, so it stays
current without being rebuilt. **Otherwise**, build a single self-contained web page with
the figures as of today, and date it.

## A layout that works

Top to bottom, most decision-relevant first:

1. **Headline:** the one or two figures the reader came for, each against its target or
   baseline where the vision sets one. Show the date the data was read.
2. **Where the business is constrained:** units ranked by constraints and redesign gaps,
   not by coverage. `rows.units`.
3. **The redesign backlog:** the top gaps, ranked, each naming its process and unit.
   `rows.backlog`.
4. **Process readiness:** a pipeline from mapped, to timed, to redesign marked up, to to-be
   proposed, to AI linked, from `readiness` on `rows.processes`.
5. **Open questions:** the newest, with the total. `rows.openQuestions` and `rows.counts`.
6. **All processes:** a table people can sort and filter by unit.
7. **Coverage:** by unit, with its definition. Useful context, not the headline.

Add the person's other sources where they belong: pipeline value beside sales processes,
for example. Don't give them a section of their own.

## Details that matter

- A unit filter, so a process owner can see only their area.
- Labels from `definitions`; a short note under each figure that needs one.
- Null shown as "not recorded", never as zero.
- Every figure attributed to its source.
