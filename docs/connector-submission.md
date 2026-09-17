# Connectors Directory submission

Canonical copy for the Anthropic Connectors Directory listing of the Kowalah
client MCP server (`https://mcp.kowalah.com/api/mcp`). Kept beside the plugin
listing copy so both can be reviewed in a diff.

Ten-step form. Only the copy is drafted here; the rest is either read live from
the server or needs a decision.

---

## Listing

**Name** (was prefilled `Kowalah Client`, corrected)

```
Kowalah
```

**Slug** — *permanent after submission*

```
kowalah
```

"Client" is internal nomenclature that exists to separate this server from the
Kowalah admin one. It has no meaning to anyone outside Kowalah and would have
been baked into the URL forever.

**One-liner** (max 200)

```
Your organisation's AI Operating Model inside Claude: read your vision map and process coverage, diagnose and redesign processes, and raise opportunities with your Kowalah team.
```

**Description** (max 2,000)

```
Kowalah is a managed AI advisory programme. Client organisations map their
business as an AI Operating Model: a tree of real processes, broken into steps,
each with an owner, a quality bar, and a decision about whether a human or an AI
runs it.

This connector puts that model inside Claude.

Read your AI vision map, your process coverage, and any process in full,
including where its cycle time actually goes and which steps have never been
measured. Redesign a process from as-is to to-be. Set acceptance criteria and
quality gates on the steps you hand to AI. Check your own training. Search
Kowalah's accelerator library before building something that already exists.
Raise an opportunity with your Kowalah team and track what they are delivering.

Everyone in your organisation can read the whole operating model. What you can
change depends on where you sit, and where you cannot edit, the connector routes
you to a proposal instead of refusing. Status views are filtered by role.

Requires a Kowalah engagement. Authentication is OAuth against your Kowalah
account, and every query is scoped to the organisations you are an accepted
member of.
```

**Categories** — up to 5, options to be read from the form.

**Author** — leave blank; defaults to company name and website.

**Icon** — leave as the server favicon. The form recommends this, and
`apps/client` already serves one. (KOW-265 listed "an icon" as a blocker. It is
not.)

## Links

| Field | Value |
|-------|-------|
| Documentation | `https://docs.kowalah.com/integrations/mcp/overview` |
| Support | `https://docs.kowalah.com` or a support address, to decide |
| Privacy policy | `https://www.kowalah.com/privacy-policy` (note `/privacy` 404s) |
| Enterprise managed auth documentation | optional, likely blank |

## Read live from the server

14 tools, 3 prompts, 35 resources, OAuth. Captured by the form on connect, not
typed in.

All 14 now carry `annotations.title`, so they list as human-readable names
rather than `kowalah_get_operating_model`. Fixed in kowalah-mcp#154.

## Still to settle

- **Reviewer test account.** The form has a "Test & launch" step. A reviewer
  needs to exercise every tool, which means an account attached to an
  organisation that actually has a vision map, an operating model with
  processes, and some delivery in flight. An empty org demonstrates nothing.
  This is the likely remaining blocker.
- **Categories**, once the option list is visible.
- **Support contact**, whether that is a docs URL or a mailbox.
