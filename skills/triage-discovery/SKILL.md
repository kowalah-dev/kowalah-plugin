---
name: triage-discovery
description: Run your organisation's discovery and triage loop from your AI assistant — start a discovery that asks people where AI could help, play back what came in, agree merges and a shortlist, score the shortlist in an ICE workshop, and take the best ideas forward into your own project or to Kowalah. For admins and core team. Use for "triage our discovery", "play back the ideas", "what came in from the discovery", "help me shortlist", "run the ICE workshop", "start a discovery", "close the discovery", "promote these ideas", or when a backlog of opportunities needs sorting.
---

# Triage a discovery

A discovery asks people across the organisation where AI could help. What comes back is
a pile of ideas of uneven quality: some duplicates, some thin, a few that matter a lot.
This skill turns that pile into a short, scored list of work the organisation has agreed
to do, and records every decision in Kowalah so the backlog stays the system of record.

The organisation triages its own ideas. Kowalah is one place an idea can go, not the gate
it has to pass through.

It works the same on the wider backlog: ideas raised outside any discovery.

## Before you start

**Check who they are.** Call `kowalah_get_update` with no query. Triage, promotion and
running discoveries are for the organisation's **admins and core team**. If the person is
a member, say so plainly: their admin or core team runs triage, and they can still raise
and improve their own ideas with `raise-opportunity`. Don't try the write tools to find
out; they will refuse.

**Which organisation?** If they belong to more than one, ask. Don't guess.

**Which discovery, or the whole backlog?** `pending_discoveries` and the home view name
the discoveries. `kowalah_get_update` with a discovery's number (DISC-…) or `id` gives its
brief, how many invitees have responded and the ideas ranked by score.

**What their plan allows.** Promoting into their own projects and running their own
discoveries need the Business plan or a Kowalah managed service. Triage itself (shortlist,
park, reject, merge, rescore) does not. If a tool says the plan doesn't include something,
pass on what it says rather than working round it.

## The rule for every write

**Nothing changes in Kowalah until the person has said yes to it.** Show each batch as a
whole first (all the merges, the whole shortlist, every rejection with its reason), let
them change it, then write it. The person who raised an idea sees what happens to it, and
a rejection's reason is shown to them, so write reasons you'd be happy for the raiser to
read.

After a batch, say what was written and what wasn't. If a call fails, stop and report it;
don't retry a different way.

## 1. Pull everything

`kowalah_list_opportunities` with the `discovery_id` (or no filter for the whole backlog).
**Page until `next_cursor` is null**, keeping the filters the same. Say how many there
are, and check the count against `total`. A playback built on the first page looks
complete and isn't.

The home view and the discovery view are summaries and stop short of the full list. Use
them for the brief and the response rate, not for the ideas.

Each row has the ICE breakdown, a short rationale per dimension, a summary of the
write-up, the department and the status. For an idea that needs more than the summary,
`kowalah_get_update` with its `id` gives it in full.

## 2. Read it back

Before anyone decides anything, show them what they've got. Lead with what helps a
decision:

- **Themes.** Group the ideas by the problem they solve, not by department. Name each
  theme in the organisation's words. Where several ideas depend on the same thing (one
  data source, one system connection, one policy), name that shared enabler: it is often
  the most valuable item in the whole discovery and nobody raised it.
- **Likely duplicates.** Ideas that describe the same work. Say why you think they match.
  Similar wording isn't enough; the same outcome for the same people is.
- **Gaps.** Ideas with no score, a thin write-up, or no named outcome. Count them.
- **Who has responded.** From the discovery view: how many of the audience have raised
  something. A low response rate is a finding about the discovery, not the ideas.

**Steps and work, not people.** Group and describe ideas by what they'd change. Don't rank
or comment on who raised what.

If they want to see it rather than read it, or share it with others, hand off to
**`programme-views`**. Its opportunities guide builds the playback view: funnel,
themes, the shortlist ranked by ICE, duplicates waiting for a decision. Don't build the
dashboard inline here.

## 3. Triage

Propose the decisions as one batch, grouped by action, with a line of reasoning for each:

- **Merge** duplicates: name which idea survives (usually the fuller write-up or the
  higher score) and which fold into it. Both must be in the same discovery, or both raised
  outside one. **Merged is final**, so be sure, and confirm merges on their own before
  anything else. The contributors of the merged idea are added to the one it folds into.
- **Shortlist** the ideas worth scoring properly in a workshop. Aim for a list the group
  can actually discuss: usually eight to fifteen.
- **Park** ideas worth revisiting later.
- **Reject** what won't be pursued, with a reason the raiser will see.

Then write each confirmed decision with `kowalah_triage_opportunity` (`merge` with
`into_id`, `shortlist`, `park`, `reject` with `reason`). `revert` takes an idea back to
captured if they change their mind about a shortlist, park or reject. A `reason` on the
other actions is posted as a comment on the idea.

## 4. Score the shortlist (the ICE workshop)

ICE is impact, confidence and ease, each 1 to 10. The composite is impact × confidence ×
ease, worked out by Kowalah.

Run it one of two ways, whichever they choose:

- **Live with the group.** Go through the shortlist one idea at a time. Show the score the
  raiser gave and their reasons, ask the group for each number, and record the agreed
  score with a sentence of why for each dimension.
- **From the scores already given.** Show where the raisers' scores look out of line with
  the write-up (a 10 for ease on something that needs a new system, say) and agree
  corrections.

Write the agreed scores with `kowalah_triage_opportunity` action `score`. Only the
dimensions you pass change, and every changed number keeps its old value in the score
history. **Don't invent numbers.** If the group can't agree, record what they can agree
and leave the rest.

Promotion needs the reasons, not just the numbers: an impact rationale (business,
productivity or adoption), a confidence rationale and an ease rationale. Capture them now
and promotion won't stall later.

## 5. Take the best forward

For each idea they want to act on, ask where the work goes. `kowalah_promote_opportunity`
offers two destinations:

- **Their own project** (`own_project`). A deliverable on one of their projects, straight
  away, for their own team or a partner to deliver. No Kowalah approval, and Kowalah isn't
  told. Pass the project, or `new_project_title` to create one. Needs the Business plan or
  a Kowalah managed service.
- **Ask Kowalah** (`ask_kowalah`). A request for Kowalah to take it on as part of their
  Kowalah engagement. It waits as `promotion_requested` until Kowalah approves it.

Help them choose on the work itself: who has the skills and the capacity, and how quickly
it needs to happen. Don't steer towards either. An idea that is better as a small piece of
expert advice is raised as an expert request in the Kowalah app; say so if it fits.

Show the full list of promotions (idea, destination, project) and confirm it before
writing. Afterwards, give each deliverable's link from the response.

## 6. Close the discovery

When the window has passed and triage is under way, `kowalah_save_discovery` action
`close` stops it taking new ideas. Confirm first. Then summarise the outcome: how many
ideas came in, how many were merged, shortlisted, parked, rejected and taken forward, and
what happens next and who owns it.

## Starting a new discovery

For "we want to ask the business where AI could help" (Business plan or a Kowalah managed
service, admins and core team):

1. **Draft the brief with them.** A name; the goal (what they want to find out); the
   business context people should anchor their ideas to; a close date, usually two to
   three weeks out; and, if they have one, a target number of ideas. Ask which of their
   own projects it sits under. If the organisation has a vision map, tie the goal to it.
2. **The audience.** Who to invite, by name and email. Ask them for the list; don't
   compile one from other sources. Show it back before adding it.
3. **Write it**: `kowalah_save_discovery` action `create`, then `add_audience`. Both need
   a yes first.
4. **Launch is in the Kowalah app.** Launching sends the invitation emails, so it happens
   in the app, not here. Give them the `launch_url` from the response and say what will
   happen when they press it. A discovery needs a goal, a close date and at least one
   person before it can launch.

While it runs, `update` changes the brief (after launch, only the name, the target and a
later close date), and `add_audience` or `remove_audience` changes who's invited.

Discoveries run by Kowalah are managed by Kowalah. If they want to change one, that's a
conversation with their Kowalah team.

## Hand-offs

- **`programme-views`** to build the playback dashboard or a summary for a steering group.
- **`raise-opportunity`** when triage turns up a gap that nobody raised.
- **`programme-review`** to check whether the shortlist is aimed at where the business is
  actually constrained.
