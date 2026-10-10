---
name: programme-views
description: Design and build something the person can share about their AI programme — a dashboard, a slide deck, a document or a short animated walkthrough — from their Kowalah operating model plus any other sources they choose. Works out who they are and who it's for, then designs it with them rather than filling a template. Use for "build our AI programme dashboard", "make me a board deck on our AI progress", "write up the steering group update", "I need something to show my team", "turn this review into slides", or any request to present the operating model to someone else.
---

# Programme views

Someone needs to show the AI programme to someone else: a steering group, a board, their
own team, a new joiner. This skill helps their AI assistant design and build that with them. It
is a design partner, not a template. The operating model is the backbone, and the person
decides what else goes in.

Three steps, in order. Don't start building until step 3 has an agreed outline.

## 1. Who they are, and who it's for

**Read before you ask.** Call `kowalah_get_update` with no query. It says who the person is,
their role in the organisation (admin, core team or member) and, where set, their home
unit. If they belong to more than one organisation, ask which one this is for.

Then ask the two questions the model can't answer:

- **Who is it for?** The reader matters more than the author. A board reads differently
  from a steering group, and a team reads differently from both.
- **What should the reader do or decide after seeing it?** A view with no decision behind
  it turns into a status report nobody acts on.

Their role suggests what they probably need. Use it as a first guess to check, never as a
box to put them in. An admin might run the programme or sponsor it, so ask which. Read the
matching guide in `references/roles/`:

| Usually | Guide |
|---|---|
| Runs the AI programme day to day | `references/roles/ai-programme-lead.md` |
| Sponsors it: accountable to the board or leadership team | `references/roles/executive-sponsor.md` |
| Owns a business process or function | `references/roles/process-owner.md` |
| Does the work in a process | `references/roles/team-member.md` |

## 2. What else they've got

The operating model holds processes, steps, coverage, the redesign backlog, open questions
and the vision. It doesn't hold everything a good view might need.

- **Look at what's connected.** Check which other tools are available in this conversation:
  a CRM, a data warehouse, a finance system, a document store. Suggest the ones that would
  add something real, such as pipeline value beside the sales processes or actual close
  dates beside the finance close. Say why each would help.
- **Use what's already known.** If memories or project files describe their priorities,
  their board's questions or a previous update, use them, and say that you did.
- **The person chooses.** Suggest, never pull in a source unasked. Some data shouldn't go
  in front of every reader, and they know which.

Keep a note of where each figure will come from. Every number in the finished piece has to
show its source.

## 3. Design it together, then build

**Agree the format.** Read the guide for the one that fits:

| Format | Good for | Guide |
|---|---|---|
| Dashboard | A view people come back to, with live figures | `references/formats/dashboard.md` |
| Slides | A meeting or a board pack; travels as a file | `references/formats/slides.md` |
| Doc | A written update people read, comment on and edit | `references/formats/doc.md` |
| Motion | A short animated walkthrough of a process or a change | `references/formats/motion.md` |

Not every format is available everywhere. What you can make depends on the assistant
you're running in, the person's plan and what their administrator has switched on. Each
guide says what to start from where a ready-made template exists, and what to produce
where it doesn't. If the format they want isn't available, say so and offer the closest
one that is.

**Agree the outline before building.** Propose the sections, what each one shows and the
source of every figure. Let them change it. A piece built without this step is usually
built again.

**Then fetch and build.** `references/data.md` covers which call returns what, how to label
each figure and what isn't available.

## Rules for every view, whatever the format

1. **Lead with where the business is constrained, not with coverage.** Coverage says how
   much has been mapped. Constraints and redesign gaps say where work is actually stuck.
   Coverage belongs in the piece, not at the top of it.
2. **Label figures from `definitions`.** Every operating-model answer says what each figure
   means. Use that wording, so a figure means the same thing on every view.
3. **Name what isn't there.** If a figure can't be produced (because it isn't recorded, or
   the model doesn't hold it), say so on the page. A gap left out reads as a gap that
   doesn't exist. A cut list says how much was cut: "10 of 29 open questions".
4. **Steps, not people.** Describe constraints, handoffs and delays as steps in a process,
   never as named people or roles. Attach outcomes to the step or process they happened
   in. A view that reads as a judgement on individuals won't get honest data next time.
5. **Be careful with time saved.** Hours saved is a real result, but in front of a team it
   can be heard as a headcount number. Say what the time is going to, if the organisation
   has said. If it hasn't, report the hours and leave the interpretation to the people
   accountable for it.
6. **Show where every number came from.** Kowalah figures cite the operating model; other
   figures cite their own system. Mixed sources with no attribution can't be checked, and
   a number nobody can check stops being trusted.
7. **Say how old things are.** Note when the vision was last updated and when figures were
   read. A view people come back to should show the date of its data.

## Hand-offs

- If they want to find the gaps before presenting them, `programme-review` does the
  analysis and this skill presents it.
- If the view shows a gap worth acting on, hand off to `raise-opportunity`.
- To report value delivered in detail, use `outcomes` alongside this skill.
