# Releasing

**Bump `version` in both manifests on every change users should receive.**

- `.claude-plugin/plugin.json` → `version`
- `.claude-plugin/marketplace.json` → `plugins[0].version`

Both, to the same number. They are read by different things and a mismatch means
some installs update and others don't.

## Why this matters more than it looks

Installed clients update on the **version**, not on the commit. Push a change
without bumping and Cowork and Claude Code keep serving the old copy from cache
— no error, no warning, no way for the user to tell. It has already happened
once here: the fix that moved `SETUP.md` into `skills/` shipped to `main` and
installed clients carried on loading six skills instead of seven until the cache
was cleared by hand.

Anthropic's CI picking up repo pushes is a different mechanism. That keeps the
*directory listing* current; it does not tell an already-installed client that
anything changed.

## What to bump

- **patch** — wording, a clarification, a fix inside one skill
- **minor** — a new skill, a new capability, a changed workflow
- **major** — a restructure, or anything that changes what an existing skill does
  enough that someone relying on it would be surprised

## Verify before you call it shipped

`claude plugin validate --strict` is not sufficient — it passed on every version
of the `SETUP.md` bug. It checks manifests, not what actually loads.

Install it clean and count the components:

```
claude plugin marketplace update kowalah
claude plugin uninstall kowalah@kowalah
rm -rf ~/.claude/plugins/cache/kowalah
claude plugin install kowalah@kowalah
claude plugin details kowalah@kowalah
```

The component inventory is the check that matters. If a skill you added isn't in
it, it isn't loading, whatever the validator says.
