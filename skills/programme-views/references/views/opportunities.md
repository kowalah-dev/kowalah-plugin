# Opportunities and discoveries

For a view of the ideas the organisation has raised: one discovery played back, or the
whole backlog. Usually built by an admin or the core team to run triage, or to show a
steering group what came in and what's being taken forward. Works in any format; a
dashboard suits triage, slides suit a workshop or a steering group.

## The data

- **Every idea:** `kowalah_list_opportunities`, with `discovery_id` for one discovery.
  Page until `next_cursor` is null and check the count against `total`. Each row carries
  the status, department, ICE breakdown and rationale, a summary, and where it was merged
  into or promoted to.
- **The discovery itself:** `kowalah_get_update` with its number (DISC-…) or `id`. The brief,
  the close date and how many of the audience have responded.

Admins and core team see every idea in the organisation. A member sees only their own, so
a member's view of the backlog is theirs, not the organisation's: say so on the page.

## A layout that works

Most decision-relevant first:

1. **Headline:** how many ideas, from how many people, against the target if the discovery
   set one; the response rate; the date the data was read.
2. **The funnel:** raised, then shortlisted, then taken forward (promotion requested and
   promoted), with merged, parked and rejected shown beside it, not hidden.
3. **The shortlist, ranked by ICE composite:** each idea with its impact, confidence and
   ease, and the one-line rationale. Unscored ideas are listed as unscored, not ranked
   last as if they scored zero.
4. **Themes:** ideas grouped by the problem they solve, with the shared enablers several
   of them depend on. Themes are your grouping, not a field in Kowalah: say so.
5. **Waiting for a decision:** likely duplicates and ideas still captured, so triage can
   work through them.
6. **Taken forward:** where each promoted idea went, their own project or Kowalah, with
   its link.
7. **Everything:** a table people can sort and filter by status, department and theme.

## Details that matter

- **Ideas, not people.** Group and describe by the work. Don't rank or label who raised
  what, and don't show a league table of contributors.
- **Statuses in plain words:** captured is "new", promotion requested is "waiting for
  Kowalah", merged is "combined with" the idea it went into.
- **Say how fresh it is.** Ideas keep moving during triage. A view that's read live stays
  current; a snapshot needs its date on it.
- **If it was cut, say so:** "showing the top 15 of 44".
