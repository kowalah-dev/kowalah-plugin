---
name: kowalah-setup
description: Connect the Kowalah MCP server and work out what the signed-in account can see. Use when the Kowalah plugin has just been installed, when Kowalah tools return nothing or error, when the user asks how to connect Kowalah, or when someone wants to start mapping an AI operating model from scratch.
---

# Setting up the Kowalah connection

The Kowalah plugin talks to `https://mcp.kowalah.com/api/mcp` over authenticated HTTP.
Every tool is scoped to the organisations the signed-in user belongs to — there is no
anonymous or read-only mode.

You do not need an existing Kowalah engagement. Signing in creates an account, and if
nobody from the user's company is here yet it creates an organisation for them too, with
them as its admin and an empty operating model to fill.

## Connecting

1. The plugin registers the `kowalah` MCP server automatically on install. On first use,
   Claude prompts to authenticate.
2. **Sign in, or sign up — with a work email address.** An email Kowalah doesn't already
   know is fine; an account is created automatically and you do not need to be invited
   first. The email domain decides where you land, so a personal address (gmail, outlook)
   will not reach a company's organisation even if one exists.
3. Approve the connection.

## Then work out which organisation they landed in

Every Kowalah account belongs to an organisation — there are no personal accounts. On
sign-up the user is placed in one of two, and the difference changes what you should do
next:

- **Their company's organisation**, if its email domain is already registered with
  Kowalah. They join it, usually as a `member`.
- **A new organisation created for them**, if it isn't. They are its sole admin, and it
  contains nothing but an automatically-created root unit.

Both authenticate identically and both are legitimate. Establish which one before doing
anything else, because the same empty result means opposite things in each.

Run **`kowalah_get_update`** with no query. A working connection returns `kind: "home"`
with the user's identity, their `organizations` (each with `id`, `name` and `role`), and a
role-appropriate rollup.

### Read three things off it

**Which organisations they belong to.** If more than one, several tools need an explicit
`organization_id` — ask which one each time rather than guessing.

**Their role.** This gates `kowalah_get_update` only: `admin` and `core_team` see
everything in the organisation, `member` sees their own opportunities plus items they are a
stakeholder on. It does **not** gate the operating model, vision map, accelerator library
or process detail — anyone in the organisation can read all of those. Writes are
permission-checked separately, and where a user cannot edit something the tools route them
to a proposal rather than refusing. An admin is a cross-cutting editor in their own
organisation, so a sole admin in a new organisation can author the whole model.

**Which of the two organisations they landed in.** Check this by *shape*, never by name.

**The organisation's name proves nothing.** A newly-created organisation is *named* from
the signer-up's email domain, so a work-email sign-up produces one named after their own
employer — indistinguishable at a glance from the company's real organisation, which may
exist separately under a near-identical name. Only a personal email address produces the
obvious *"Sam's organization"* giveaway.

The reliable tell that this is a **new, empty organisation** is all four together:

- exactly **one** organisation, and `role` is `admin`
- `kowalah_get_operating_model` returns **one unit and zero processes** — note this is
  *not* `kind: "empty"`, because a root unit is created automatically, so the model looks
  present but is bare
- `kowalah_get_vision` returns `kind: "empty"`
- `kowalah_get_update` shows no projects, deliverables or expert requests despite the
  `admin` role that would reveal them

## What to do about it

Say plainly which of the two they are in, then ask what they expected, because that is
what decides the next step.

### They are in a new organisation of their own, and that is fine

This is the normal starting point for someone with no Kowalah engagement: an AI Operations
Lead, an internal forward deployed engineer, or anyone who owns AI delivery inside a
business and has nothing mapped yet. They are the admin, the model is empty, and they can
author all of it.

Offer to start. The first useful move is one org unit and its real processes, not an
attempt at the whole company:

- `kowalah_save_org_unit` to add the units under the root
- `kowalah_save_process` and `kowalah_save_process_step` to capture how work actually runs
- `kowalah_create_opportunity` to log what is worth automating as it comes up

Build it a function at a time, in the conversation where they are already describing how
their business works. Coverage matters more than depth early on — a shallow map of several
functions is worth more than a deep map of one.

What a solo model cannot do is check itself. It is one person's account of how the
business runs until the people who own those processes confirm their own, which is what
bringing the rest of the organisation in is for. Mention that when it becomes relevant,
not up front.

### They expected their company's organisation and did not get it

If their company already works with Kowalah, or colleagues are already using it, landing
in a new organisation of their own is the wrong outcome. Their work would go somewhere
nobody else can see.

Say so before they start building. The resolution is their Kowalah contact or their
organisation's AI lead attaching the account to the right organisation, and it is worth
doing first rather than migrating later.

### They are in their company's organisation

The working case. If the model or vision come back `kind: "empty"` here, the connection is
fine and nothing has been authored yet. That is Define-phase work the Kowalah team does
with the client, so don't offer to build it from scratch — check with their Kowalah
contact instead.

Once they're connected, offer `my-ai-tools` as a natural next step: it shows them which AI
tools their Claude has, fixes anything half set up, and lets them share their setup with
the organisation's AI register. Offer it once; it's optional.

## If something fails

- **401 / authentication error** — the session expired. Re-authenticate.
- **`User not found for Clerk user: …`** — sign-in worked, but the matching Kowalah
  account record was never created. This is a provisioning failure, not something the user did.
  Their Kowalah contact resolves it.
- **`User … has no active organization memberships`** — signed in, but attached to nothing
  at all. Rare, and also a provisioning failure. Same route.
- **Tools succeed but return nothing** — usually the new-organisation case above. Work out
  which of the two situations it is before treating it as a problem: for someone starting
  fresh it is the expected state and the answer is to start mapping.
