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

## Shipping a release to clients

Client org admins install from a zip, not from this repo — Anthropic requires organization
marketplaces to be **private or internal** repositories, and this one is public so it can
be submitted to the plugin directory. Those two requirements are mutually exclusive, so
the zip is the bridge.

1. Bump both manifests (above) and merge to `main`.
2. Tag it: `git tag v0.3.0 && git push origin v0.3.0`
3. The `release` workflow validates, builds `dist/kowalah-plugin-<version>.zip`, checks the
   tag matches the manifest version, and attaches it to a GitHub Release.
4. Tell client admins to re-upload. Upload replaces by plugin **name**, so they do not need
   to delete the old one.

Build it locally with `./scripts/package.sh` if you need a zip without cutting a release.

**There is no auto-update on this path.** A client stays on whatever zip their admin last
uploaded, however many times we push. Say so plainly when someone asks whether a fix has
reached them — "we shipped it" and "they have it" are different facts here.

The one path that does auto-update is a *private* repo synced by the admin, where sync
"runs when a pull request that includes a plugin version bump is merged to the repository's
default branch". That is the same version discipline as above, which is why it is not
optional.
