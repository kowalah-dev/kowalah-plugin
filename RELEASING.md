# Releasing

One version number covers every platform: Claude, Codex, Cursor and Microsoft 365
Copilot. Microsoft refuses versions that start with 0, so we stay on 1.x and up.

## 1. Prepare on `staging`

1. Branch from `staging`, make the change, open a PR to `staging`.
2. Bump the version in all five manifests, in the same PR or a release PR:
   `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`,
   `.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json`,
   `.cursor-plugin/marketplace.json`.
3. Check locally:

   ```bash
   claude plugin validate .
   node scripts/validate-cursor-plugin.mjs
   ./scripts/package.sh
   ```

## 2. Release from `main`

Every merge to `main` sends the plugin to Anthropic's directory for review, so batch
changes on `staging` and merge to `main` only when a release is ready.

1. Merge `staging` into `main`.
2. Tag the merge commit `vX.Y.Z`, matching the manifests, and push the tag.
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
provisioning files.
