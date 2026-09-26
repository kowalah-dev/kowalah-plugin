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

**CI runs it without `--strict`, on purpose.** Anthropic's directory review runs
the non-strict check too, and publishes versions that carry warnings — ours did.
`--strict` also fails on `privacyPolicyUrl`, which the directory asks for and the
validator calls an unknown field. Holding the release to a harder bar than the
directory that judges it only blocks our own zip build. Don't add `--strict` back
without reading this paragraph.

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

## How a release reaches people

There are three routes, and they update differently. That difference is the thing
to get right when someone asks whether a fix has reached them.

### 1. Someone adds this repo as a marketplace (auto-updates)

The default, and the one to recommend. In Claude, **Customize → Plugins → Add →
Add marketplace**, then `https://github.com/kowalah-dev/kowalah-plugin`. It
accepts a public repo, and **Sync automatically** defaults to on, so they pick up
what we push without doing anything.

Same in Claude Code: `/plugin marketplace add kowalah-dev/kowalah-plugin`.

### 2. An org admin uploads the zip (manual updates)

Organization marketplaces are the one place a public repo is refused: Anthropic
requires them to be **private or internal**. This repo is public on purpose so it
can be submitted to the plugin directory, so an admin who wants managed rollout
with access controls uploads a zip instead.

1. Bump both manifests (above) and merge to `main`.
2. Tag it: `git tag v0.3.0 && git push origin v0.3.0`
3. The `release` workflow validates, builds `dist/kowalah-plugin-<version>.zip`,
   checks the tag matches the manifest version, and attaches it to a GitHub
   Release.
4. Upload the zip to the Blob store so `kowalah-plugin.zip` points at it, since
   that is the link the docs give out.
5. Tell client admins to re-upload. Upload replaces by plugin **name**, so they
   do not need to delete the old one first.

Build a zip locally with `./scripts/package.sh` if you need one without cutting a
release.

**Nothing auto-updates on this route.** A client stays on whatever zip their admin
last uploaded, however many times we push. "We shipped it" and "they have it" are
different facts here, so say which one you mean. If an admin would rather not
track releases, point them at route 1 instead.

### 3. The Anthropic plugin directory (live since 24 September)

Puts us in the catalog with no URL to paste. Requires the repo to stay public.
Pushes to `main` are picked up by a scheduled check about every 6 hours; a
reviewer at Anthropic then makes a scanned version live, so a push is a request
to publish, not a publish. Manage it at
[the submission page](https://claude.ai/directory/manage/plugins/a4be1a55-fa04-473d-90f0-a5e020071f3a).

The listing's short description and display name are read from the **live
version's manifest** — the details recorded on the Listing tab are a frozen copy
of the original submission form and cannot be edited. So listing copy changes
ship as a version bump, like anything else.

## Why the version bump matters on every route

- **Route 1** syncs on repository changes, and an admin-synced private repo syncs
  specifically "when a pull request that includes a plugin version bump is merged
  to the repository's default branch".
- **Route 2** overwrites by plugin name, and the version is how anyone can tell
  which build they are looking at in the plugin detail view.
- The Blob download is cached for an hour, so the version is also how you confirm
  a re-upload actually landed.

None of those work if the number never moves.
