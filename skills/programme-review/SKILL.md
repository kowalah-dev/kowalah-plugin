---
name: programme-review
description: Review the state of an AI operating model programme — coverage, where constraints concentrate, and whether the work in flight is aimed at the actual gaps. Use for "how is our AI programme going", "where are we with AI", "what should we do next", "prep me for the steering group", or any org-wide or divisional read of AI progress.
---

# Programme review

For the person accountable for AI across an organisation or a division: the AI programme
lead, the core team, the exec sponsor. The job is to say where the programme actually is
and what should happen next — not to recite a dashboard.

## The one failure mode this skill exists to prevent

**A portfolio of initiatives aimed at places that had no gap.** It is the most common
finding and the least comfortable one. Coverage climbs, everyone reports green, and none
of the work is pointed at where the business is actually constrained. Every review must
end by testing the in-flight work against the gaps — not by reporting them on separate
slides.

## Sequence

1. **`kowalah_get_operating_model`** — the world view. Returns the unit tree with coverage
   roll-ups on every node, org-wide totals, and a `vision` block if one has been authored.
2. **Read the totals properly** (see below). Pick the two or three units where the
   constraints and redesign gaps actually concentrate.
3. **`kowalah_get_operating_model_unit`** on each of those — its subtree roll-up, the
   processes it owns, and `topBacklog`, the ranked redesign backlog across its processes.
4. **`kowalah_get_update`** with no query — the portfolio of what is actually in flight:
   projects, deliverables, expert requests, opportunities, client-visible risks.
5. **Cross-reference.** For each significant in-flight item, name the unit and process it
   is aimed at. Then name the top-backlog items with nothing pointed at them.

Steps 4 and 5 are not optional. A review that stops at step 3 is a coverage report.

## Reading coverage honestly

**Coverage % is the vanity metric.** It says how much of the mapped business has processes
recorded against it. It says nothing about whether those processes are any good, whether
anyone is working on them, or whether the ones that matter are covered. Never lead with it.

**Lead with where constraints concentrate.** The roll-ups carry `constraint count` and
`redesign-gap count` across each unit's whole subtree. A unit at 80% coverage with fifteen
constraints is in worse shape than one at 40% with two. Say that plainly.

**Mind the denominator.** Roll-ups cover what has been *mapped*. A division with no
processes recorded shows no constraints — not because it has none, but because nobody has
looked. If a unit's process count is zero or near it, that absence is the finding. Do not
let an unmapped unit read as a healthy one.

**Coverage moving is not progress.** Mapping more processes raises coverage without
changing anything about how the business runs. Progress is constraints closing and
redesigns landing. If coverage rose and the constraint count did not fall, say so.

## Using the vision map

When a `vision` block comes back, it carries the vision statement, the guiding principles,
and the programme success measures — in the organisation's own words, from their AI Vision
Day.

Each principle has defining attributes as an assertion plus a counter-clause: *"It moves a
business KPI." / "Not a good idea in search of one."* **That pair is the test.** Apply both
halves. The counter-clause is the half that does the work — it is what lets you say a
piece of in-flight work is off-vision without it being an opinion.

Quote the principles in their own words. Do not paraphrase them into generic AI-strategy
language; the specific wording is the thing the organisation agreed to.

When `kowalah_get_operating_model_unit` returns a vision with `ownership: "inherited"`, say
whose it is — "you are working to the group vision, this division hasn't authored its own"
is itself a finding worth surfacing.

## What a good review says

Four things, in this order:

1. **Where the business is constrained** — named units, named processes, with numbers.
2. **Whether the work in flight is aimed there** — the cross-reference from step 5, with
   both the hits and the misses.
3. **What is unmapped** — where you cannot say anything because nobody has looked.
4. **The next decision** — not a list of everything possible; the one or two things that
   would change the picture, and who has to decide.

Where the user wants to act on a gap, hand off to `raise-opportunity` rather than writing
the opportunity inline — it checks the accelerator library first and gets the ICE score and
vision test right.

## Scope and permissions

`kowalah_get_update` returns different things by role. Admins and core team see everything
in the organisation; members see only their own opportunities plus items they are a
stakeholder on. If the user is a member, the portfolio view is partial by design — say so
rather than presenting it as the whole picture.

If the user belongs to more than one Kowalah organisation, the model tools need an
`organization_id`. Call `kowalah_get_update` with no query first to list their
organisations, then ask which one — do not guess.

If either model tool returns `kind: "empty"`, no operating model or vision has been mapped
yet. That is Define-phase work their Kowalah team does with them; say that rather than
offering to map it from scratch here.

One thing to rule out first: a model showing **one unit and zero processes** in an
organisation named after a person, where the user is `admin`, is not an unmapped client —
it is an auto-provisioned personal workspace not attached to any engagement. The two look
alike and the remedies are unrelated. See `SETUP.md`.
