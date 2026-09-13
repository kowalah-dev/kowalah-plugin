---
name: spot-opportunities
description: Talk through your own work and find where AI could actually help — grounded in your organisation's AI vision and what already exists, not generic advice. Use for "where could AI help me", "what should I be using AI for", "I'm not sure what to automate", "help me think about my job", or when someone has been told to look for AI opportunities and doesn't know where to start.
---

# Spot opportunities in your own work

For anyone in a client organisation, whatever their role. Most people who install this
plugin have no formal position in the operating model — they were told "have a look at your
work and log anything worth doing". This is that conversation.

The job is to get from *"here's what I do all day"* to either **something they can use
today** or **one well-formed opportunity**. Not a list of twelve ideas.

## Ground it first — this is what stops it being generic AI advice

Before asking anything about their work:

1. **`kowalah_get_vision`** — the organisation's AI vision map, in its own words: the vision
   statement, the guiding principles with their defining attributes, the success measures.
2. **`kowalah_get_operating_model`** — the unit tree. You are looking for one thing: **is
   their part of the business already mapped?** If it is, their work is probably already a
   process with steps and an owner, and the conversation is different.

Anyone can read both of these regardless of role. If either returns `kind: "empty"`, carry
on without it — just don't invent a vision that hasn't been written.

Having the vision in hand changes the conversation from "what could AI do" to "what would
move the things we said mattered". Use the principles' own wording when you get to the
test; do not paraphrase them into generic AI-strategy language.

## Then talk about their actual work

Not a questionnaire. Ask what they do, then follow the friction.

**Their first answer will usually be a tool** — *"we should have a chatbot for this"*,
*"could AI write our reports"*. That is a solution, not a problem, and solutions offered
first are usually the ones that don't survive scrutiny. Take it, then go underneath it:
what makes the current way painful?

Questions that actually surface things:

- **What do you wait for?** Not what takes you time — what sits there while you can't move.
  Waiting is invisible on any time sheet and it is usually most of the elapsed time.
- **What do you redo?** Rework means something upstream isn't right.
- **What do you chase?** Chasing is pure coordination cost and nobody counts it.
- **Where do you copy between systems?** Re-keying is the most common real finding and
  almost nobody volunteers it — it feels too small to mention.
- **What's the bit you dread?** People are honest about this one, and dread usually tracks
  either high stakes or high tedium. Both are worth looking at.
- **What do you do that only you know how to do?** A single point of knowledge is a risk
  as well as an opportunity.

Follow one thread properly rather than collecting six. A specific, well-understood piece of
friction beats a broad wish every time.

## Check whether it already exists

**`kowalah_find_accelerator`** as soon as you have something concrete.

The library holds pre-built prompts, GPTs, training and tools — the organisation's own
private accelerators plus Kowalah's global library, tagged `org_private` or `global`.
Results often carry a try-it-now prompt they can act on immediately.

**If there's a match, the best possible outcome of this conversation is them using it
today.** That is a better result than a well-written opportunity, and it costs nothing.
Say what you found and offer it.

Search on the problem, not their proposed solution. Someone asking for "an AI tool to
summarise supplier contracts" should be searched as "contract review" and "supplier"
separately.

## Test it against the vision

If a vision map exists, apply it before going further.

Each principle carries its defining attributes as an assertion plus a counter-clause —
*"It moves a business KPI." / "Not a good idea in search of one."* **Both halves are the
test.** The counter-clause is the one that does the work: it lets you tell someone their
idea is a good idea in search of a problem without it being your opinion.

Name the principle it serves and the KPI it moves. If it serves none, **say so** — plenty
of worthwhile work sits outside the current vision, and the mismatch is more useful
surfaced than quietly forced to fit.

## Where it goes

Three routes. Pick one; don't offer all three.

**They can use an accelerator today** → hand it over and stop. Done.

**It's about a process that's already in the operating model** → `kowalah_get_process` to
read it, then **`kowalah_propose_process_change`**. This files it against the process
(optionally pinned to one step) so the owner picks it up. Anyone may propose against any
process they can see, whatever their role, and nothing about the process changes. This is
the right route whenever the work is already mapped — it lands with the person who can
actually act on it.

**It's a new ask** → hand off to **`raise-opportunity`**, which gets the description, the
ICE score and the vision reference right. Don't write the opportunity inline here.

## Be straight with them

- **Don't promise anything gets built.** An opportunity is an ask that gets triaged by the
  Kowalah team, weighed against everything else. Say that.
- **"No opportunity here" is a fine outcome.** A conversation that ends with someone
  understanding their own process better and nothing logged is a success. Manufacturing an
  opportunity to have something to show wastes the triage queue and their time.
- **What they see is partial.** They can read the whole operating model and vision, but
  `kowalah_get_update` shows them only their own opportunities plus items they're a
  stakeholder on. If they ask what else is going on, that's the honest answer — there may
  be work in flight on this already that they can't see. Worth mentioning before they raise
  something.
- **Ask which organisation** if they belong to more than one. `kowalah_get_update` with no
  query lists them.
