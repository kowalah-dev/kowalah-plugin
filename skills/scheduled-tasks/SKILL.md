---
name: scheduled-tasks
description: Help someone set up a scheduled task in their AI assistant that brings them something useful from Kowalah on a regular basis — what's new in their accelerator library, a draft of their weekly programme update, the week in their area, progress against their vision, or ideas from their own work. Suggests ideas that fit their role, lets them choose, then writes the task. Use for "set me up a weekly update", "keep me posted on new accelerators", "can this run every Friday", "remind me each week", "automate my steering update", or "what could I schedule?".
---

# Scheduled tasks

A scheduled task is a prompt the person's assistant runs on a timetable, on its own: every
Monday morning, every Friday afternoon, the first of the month. Set up well, it brings
them something they'd otherwise have to remember to ask for. This skill suggests tasks
that fit them, lets them choose, and writes the task so it works without this
conversation.

**The person chooses and creates the task.** You suggest; they decide what runs, how
often and where the results go. Nothing is set up without their yes.

## 1. Who they are

Call `kowalah_get_update` with no query. It gives their role in the organisation (admin,
core team or member) and, where set, their home unit. If they belong to more than one
organisation, ask which one this is for.

Then ask, in one go:

- **What would they like to hear about, or stop doing by hand?** Their answer beats any
  suggestion.
- **When?** Which day and time suits them, and how often.
- **Where should the result go?** A message in their assistant is the default. If they
  have email, chat or a document store connected, they may want it there instead.

## 2. Suggest a few ideas

Read `references/ideas.md` and suggest two or three ideas that fit their role and what
they told you. Say in a sentence what each would give them, and let them pick one. One
good task they keep beats four they switch off.

Ideas fall into two kinds:

- **Ones that tell them something:** what's new in their library, the week in their area,
  progress against the vision. Read only. A good first task for anyone.
- **Ones that draft something for them:** their programme update, ideas from their own
  work. The task prepares a draft; the person reviews it and decides what happens next.

## 3. Write the task, then create it

Write the task prompt from the matching idea's template, filled in for this person. A
scheduled run starts fresh, with none of this conversation, so the prompt must stand on
its own:

- **Name the organisation and, if it applies, the unit**, by name, so the run doesn't
  have to ask.
- **Say what to call and how to read it**, including "use the date of the previous run as
  `since`; on the first run, use seven days ago".
- **Say exactly what to report and in what form,** including what to say when there's
  nothing new. A short "nothing new this week" is better than padding.
- **Include the rules below** that apply to the idea.

Show them the prompt, the timing and where the result goes. Change anything they want.
Then, once they say yes, ask the assistant to create a scheduled task with that prompt and
timing. If their assistant can't create scheduled tasks, or they'd rather do it
themselves, give them the prompt and timing to set it up in their assistant's settings.

## Rules for every scheduled task

1. **Nothing is shared or saved on its own.** A scheduled run reads and drafts. Anything
   that would be written to Kowalah (an opportunity, a process change, an outcome) is put
   to the person to approve, never submitted by the run.
2. **Report what was checked.** The "what's new" answer lists what it `covers`. Report
   those, and don't suggest anything else was looked at.
3. **Steps, not people.** When a task describes work, delays or constraints, it describes
   steps in a process, never named colleagues.
4. **Their own work stays theirs.** A task that looks at the person's own calendar or
   documents leaves personal items out, only suggests, and shows them everything before
   anything goes further.
5. **Quiet when there's nothing.** If nothing has changed, say so in a line and stop.

## Hand-offs

- To change or stop a task later, the person does it in their assistant's settings, or
  asks their assistant.
- If a run turns up something worth acting on, the person can pick it up with
  `raise-opportunity`, `process-diagnostic` or `programme-views` in a normal
  conversation.
