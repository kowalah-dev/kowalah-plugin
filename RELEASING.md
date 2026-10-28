# Releasing

One version number covers every platform: Claude, Codex, Cursor and Microsoft 365
Copilot. Microsoft refuses versions that start with 0, so we stay on 1.x and up.

## What each kind of change needs

Not every change needs every platform. Claude and Cursor read this repo, so they follow
`main`. ChatGPT, Codex and Microsoft 365 take a package that we upload and that goes
through their own review, so they only move when we choose to resubmit.

| Change | Version | Claude and Cursor | ChatGPT, Codex and Microsoft 365 |
|---|---|---|---|
| Outside the plugin: README, RELEASING, workflows, scripts | No bump | Batch into the next release. On its own, a merge to `main` rescans at the same version | Nothing |
| Wording in an existing skill | Patch: `1.0.x` | Next batched release | Optional. Bring them along with the next store release, unless the change matters to their users |
| A new or removed skill, or a skill that needs a new server tool | Minor: `1.x.0` | Release | Resubmit both. OpenAI: build with `--review` and update `openai/review.json` test cases for the new skill. Microsoft: sync the skills, build the prod package, run deep validation, resubmit in Partner Center with the notes and reviewer PDF updated |
| Manifests or connector: server URL, sign-in, names, icons | Minor | Release | Resubmit both, and expect a full review. Microsoft: a sign-in change may need prod provisioned again (see `m365/plugin/README.md` in the companion repo) |
| Server only (kowalah-mcp tools) | No plugin release | Check the skills still describe what the tools return | OpenAI rescans the server itself. Update review test cases if a tool changes shape |

When the stores lag behind `main`, they carry the last version we sent them, and the
version number alone no longer says which skill text a user has. Note on the release's
Linear issue which version each store is on, and close the gap at the next store release.

## 1. Prepare on `staging`

1. Branch from `staging`, make the change, open a PR to `staging`.
2. Bump the version in all four manifests, in the same PR or a release PR:
   `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`,
   `.codex-plugin/plugin.json` and `.cursor-plugin/plugin.json`.
   (`.cursor-plugin/marketplace.json` carries the marketplace's own version, not the
   plugin's.)
3. Check locally:

   ```bash
   claude plugin validate .
   ./scripts/package.sh
   ```

   The Cursor manifests are checked by the companion repo's CI and `scripts/verify.sh`
   (see section 3), not here.

## 2. Release from `main`

Every merge to `main` sends the plugin to Anthropic's directory for review, so batch
changes on `staging` and merge to `main` only when a release is ready.

1. Run **Validate** on `staging` in Anthropic's developer portal
   (claude.ai/directory/manage → Submit new → Plugin bundle → `kowalah-dev/kowalah-plugin@staging`).
   It shows the directory's findings without submitting anything. Fix any new policy hold
   on `staging` first, then press **Start over** to clear the form.
2. Merge `staging` into `main`.
3. Tag the merge commit `vX.Y.Z`, matching the manifests, and push the tag.
   `release.yml` validates, builds the zips and attaches them to a GitHub Release. It
   fails if the tag and the manifest version differ.

## 3. Other directories and Microsoft 365

Review material for directory submissions and the Microsoft 365 Copilot package live in
Kowalah's private companion repo, `kowalah-plugin-review`. It pins this repo at a release
tag and checks every weekday that it is still on the latest one. After tagging:

1. In `kowalah-plugin-review`, move `upstream/` to the new tag and sync the Microsoft 365
   skills (its README has the commands).
2. Run its `scripts/verify.sh`. It runs this repo's validators at that tag and checks the
   Microsoft 365 and OpenAI packages against it.
3. Submit or resubmit where needed: OpenAI, Partner Center, Cursor.

## Keep out of this repo

Anthropic's directory scans the whole repo as the plugin, not just what Claude loads.
Anything used only to list, review or package the plugin for another store goes in the
companion repo: test cases, screenshots and their tooling, store packages and their
provisioning files, and validators for other platforms' manifests. The scan held every
release from 0.7.0 to 1.0.1 because it read the Cursor validator script as reading a
credential.
