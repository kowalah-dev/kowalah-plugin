# kowalah-plugin

Public. The Kowalah plugin for Claude, Codex and Cursor, and the source of the skills
the Microsoft 365 Copilot package uses.

- Read `RELEASING.md` before changing versions, merging to `main` or tagging. Merging to
  `main` sends the plugin to Anthropic's directory for review: batch on `staging`.
- Anthropic's directory scans the whole repo. Don't add store listing material, review
  test cases, screenshots or packaging for other stores here; they go in the private
  companion repo `kowalah-plugin-review` (usually checked out at
  `~/Code/kowalah-plugin-review`).
- When checking a change for another platform, verify in the companion repo with its
  `scripts/verify.sh`, which builds from a released tag of this repo.
- Never commit tenant IDs, app IDs, client names, client data or test results.
- British English, plain and short.
