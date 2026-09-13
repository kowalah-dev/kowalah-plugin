---
name: kowalah-setup
description: Connect the Kowalah MCP server and check what the signed-in account can actually see. Use when the Kowalah plugin has just been installed, when Kowalah tools return nothing or error, or when the user asks how to connect Kowalah.
---

# Setting up the Kowalah connection

The Kowalah plugin talks to `https://mcp.kowalah.com/api/mcp` over authenticated HTTP.
Every tool is scoped to the organisations the signed-in user belongs to — there is no
anonymous or read-only mode.

## Connecting

1. The plugin registers the `kowalah` MCP server automatically on install. On first use,
   Claude prompts to authenticate.
2. **Sign in, or sign up.** An email Kowalah doesn't already know is fine — an account is
   created automatically. You do not need to be invited first.
3. Approve the connection.

## Then check what the account can actually see — this step matters

Signing in successfully is **not** the same as having access to anything. A brand-new
sign-up lands in a personal workspace of its own with nothing in it. Authentication
succeeds, every tool returns valid empty results, and nothing says why. Establish which
situation the user is in before doing anything else.

Run **`kowalah_get_update`** with no query. A working connection returns `kind: "home"`
with the user's identity, their `organizations` (each with `id`, `name` and `role`), and a
role-appropriate rollup.

### Read three things off it and tell the user

**Which organisations they belong to.** If more than one, several tools need an explicit
`organization_id` — ask which one each time rather than guessing.

**Their role.** This gates `kowalah_get_update` only: `admin` and `core_team` see
everything in the organisation, `member` sees their own opportunities plus items they are a
stakeholder on. It does **not** gate the operating model, vision map, accelerator library
or process detail — anyone in the organisation can read all of those. Writes are
permission-checked separately, and where a user cannot edit something the tools route them
to a proposal rather than refusing.

**Whether this is a real client organisation or an auto-provisioned workspace.** This is
the one that catches people out, so check it by *shape*, never by name.

**The organisation's name proves nothing.** A new workspace is named from the signer-up's
email domain, so someone joining on a corporate address gets a workspace named after their
own employer — indistinguishable at a glance from the real client organisation, which may
exist separately with a near-identical name. Only a personal email address produces the
obvious *"Sam's organization"* giveaway.

The reliable tell is all four of these together:

- exactly **one** organisation, and `role` is `admin`
- `kowalah_get_operating_model` returns **one unit and zero processes** — note this is
  *not* `kind: "empty"`, because a root unit is created automatically, so the model looks
  present but is bare
- `kowalah_get_vision` returns `kind: "empty"`
- `kowalah_get_update` shows no projects, deliverables or expert requests despite the
  `admin` role that would reveal them

That combination means the account was auto-provisioned into a workspace of its own and is
not attached to a Kowalah engagement. **Say so plainly.** Every tool will keep returning
nothing, and the user cannot fix it themselves. The resolution is their Kowalah contact or
their organisation's AI lead attaching the account to the right organisation.

Do not present an empty operating model as "you haven't mapped anything yet" without
ruling this out. The two are identical on the surface and the remedies are unrelated.

## If something fails

- **401 / authentication error** — the session expired. Re-authenticate.
- **`User not found for Clerk user: …`** — the account exists in Clerk but the matching
  record was never created. This is a provisioning failure, not something the user did.
  Their Kowalah contact resolves it.
- **`User … has no active organization memberships`** — signed in, but attached to nothing
  at all. Rare, and also a provisioning failure. Same route.
- **Tools succeed but return nothing** — almost always the personal-workspace case above.
  Check it before assuming the data is missing.
- **`kind: "empty"` from the model or vision tools in a *real* client organisation** — the
  connection is fine and nothing has been authored yet. That is Define-phase work the
  Kowalah team does with the client; don't offer to build it from scratch here.

## No Kowalah engagement?

Signing in will work and create an account, but the tools will have nothing to show.
Kowalah is a managed AI advisory programme — see https://kowalah.com.
