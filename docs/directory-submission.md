# Plugin directory submission

Canonical copy for the Anthropic plugin directory listing
(claude.ai/admin-settings/directory/submissions/plugins/new). Kept here so the
listing can be reviewed in a diff, and so it can be updated deliberately when the
plugin changes rather than rewritten from memory in a form field.

The form has no character limits. Everything below is short because directory
listings get skimmed, not read.

---

## Link to plugin

```
https://github.com/kowalah-dev/kowalah-plugin
```

## Plugin homepage

```
https://docs.kowalah.com/integrations/plugins/kowalah-plugin
```

## Plugin name

```
Kowalah
```

## Plugin description

```
Run your organisation's AI operating model from inside Claude.

Kowalah clients map their business as an AI Operating Model: a tree of real
processes, broken into steps, each with an owner, a quality bar, and a decision
about whether a human or an AI runs it. This plugin puts that map into Claude,
along with the judgement to read it honestly.

Read your AI vision map and process coverage. Diagnose where a process actually
loses time, and tell the difference between work that is slow and work that is
waiting. Redesign a process from as-is to to-be. Set acceptance criteria and
quality gates on the steps you hand to AI. Find where AI could help in your own
work and raise it with your Kowalah team.

Requires a Kowalah engagement. The bundled connector authenticates with your
Kowalah account and every tool is scoped to the organisations you belong to.
```

## Example use cases

```
Example 1: Prepare for a steering group. Ask "how is our AI programme going" and
Claude reads your operating model coverage, finds where constraints and redesign
gaps actually concentrate, tests it against your AI vision principles, then
cross-references the projects and Expert Requests already in flight, so you can
see which gaps have nothing pointed at them.

Example 2: Diagnose a slow process. Ask "walk me through supplier onboarding" and
Claude reports where the time really goes, how many handoffs there are, and which
steps have never been measured. A process that is 0.4% work and 99.6% waiting
cannot be fixed by making the work faster, and it says so rather than reporting a
tidy average.

Example 3: Redesign a process for AI. Mark which steps to eliminate, merge or
keep, then generate a to-be version held beside the original so the two can be
compared. The point is "these ten steps become three", not the same process run
slightly faster.

Example 4: Set the quality bar before handing a step to AI. Define what a good
output looks like in your own words, then attach a gate that blocks the step
until it passes, or a monitor that samples it. A step set to run autonomously
requires a named stop-condition that returns control to a human.

Example 5: Log an AI opportunity. Describe an idea and Claude checks Kowalah's
accelerator library first in case it already exists, tests it against your AI
vision principles, captures an impact/confidence/ease score, and submits it to
your Kowalah team with a reference number.
```

## Submission details

| Field | Value | Note |
|-------|-------|------|
| Platforms | Claude Code, Claude Cowork | **Decide before submitting.** The form says "test that the plugin works with these surfaces before submitting". Both have been verified to *install* and load 7 skills plus the connector. Neither has been run end to end against a real client organisation. |
| License type | MIT | **Open question.** Current repo licence, but these skills encode Kowalah methodology. See KOW-265. |
| Privacy policy URL | `https://www.kowalah.com/privacy-policy` | Note `/privacy` 404s. |
| Submitter email | charlie@kowalah.com | Pre-filled. |

## Before submitting

- Ticking the consent box agrees to Anthropic's Software Directory Terms, and the
  listing information becomes publicly visible.
- Submission does not guarantee inclusion, and there is no guarantee of the
  "Anthropic Verified" badge.
- After publication, pushes to this repo are picked up automatically. No
  re-submission is needed for updates, which makes the version discipline in
  RELEASING.md load-bearing.
