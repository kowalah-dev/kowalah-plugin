---
name: kowalah-setup
description: Connect the Kowalah MCP server and verify access. Use when the Kowalah plugin has just been installed, when a Kowalah tool returns an authentication error, or when the user asks how to connect Kowalah.
---

# Setting up the Kowalah connection

The Kowalah plugin talks to `https://mcp.kowalah.com/api/mcp` over authenticated HTTP.
**It requires a Kowalah client account** — every tool is scoped to the organisations the
signed-in user belongs to. There is no anonymous or read-only mode.

## Connecting

1. The plugin registers the `kowalah` MCP server automatically on install. On first use,
   Claude will prompt to authenticate.
2. Sign in with the Kowalah client account — the same login used for the Kowalah client
   portal. This is a **different** account from any Kowalah admin or employee login.
3. Approve the connection.

## Verifying it worked

Run `kowalah_get_update` with no query. A working connection returns `kind: "home"` with
the user's identity, their organisations, and a role-appropriate rollup.

Read two things off that response and tell the user:

- **Which organisations they belong to.** If more than one, several tools need an explicit
  `organization_id` and you must ask which one each time rather than guessing.
- **Their role.** `admin` and `core_team` see everything in the organisation; `member` sees
  only their own opportunities plus items they are a stakeholder on. This changes what
  every other skill can say, so establish it early.

## If it fails

- **401 / authentication error** — the session has expired or the wrong account was used.
  Re-authenticate with the Kowalah *client* login.
- **No organisations returned** — the account exists but is not an accepted member of any
  organisation. Their Kowalah contact resolves this; nothing in this plugin can.
- **`kind: "empty"` from the model or vision tools** — the connection is fine, but no
  operating model or vision map has been authored yet. That is Define-phase work the
  Kowalah team does with the client. Do not offer to build it from scratch here.

## No Kowalah account?

The tools will not work, and nothing in this plugin substitutes for them. Kowalah is a
managed AI advisory programme — see https://kowalah.com.
