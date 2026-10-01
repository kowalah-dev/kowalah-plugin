#!/usr/bin/env bash
# Build the distributable plugin zips: one for Claude, one for OpenAI.
#
# Claude: for upload to a client's org plugin library. Anthropic refuses PUBLIC
# repositories as organization marketplaces ("Your repository must be private
# or internal"). This repo is public — deliberately, because the Anthropic
# plugin directory refuses closed-source submissions. The two requirements are
# mutually exclusive, so a client admin who wants this in their org library
# uploads a zip instead. Upload replaces by plugin NAME, so re-uploading
# overwrites the previous version with no delete step.
#
# OpenAI: for the ChatGPT and Codex plugin directory, which takes a ZIP upload
# and never reads this repository. Every release needs a fresh upload there;
# the MCP server itself is re-scanned by OpenAI daily and needs nothing.
set -euo pipefail
cd "$(dirname "$0")/.."

# Skills that only make sense in Claude, left out of the OpenAI zip. Empty:
# my-ai-tools used to be one, and now works in any assistant (KOW-293). Keep
# the mechanism for the next skill that genuinely can't travel.
CLAUDE_ONLY_SKILLS=()

version_of() { python3 -c "import json,sys;d=json.load(open(sys.argv[1]));print(d['plugins'][0]['version'] if 'plugins' in d else d['version'])" "$1"; }

VERSION=$(version_of .claude-plugin/plugin.json)
MKT=$(version_of .claude-plugin/marketplace.json)
CODEX=$(version_of .codex-plugin/plugin.json)

if [ "$VERSION" != "$MKT" ] || [ "$VERSION" != "$CODEX" ]; then
  echo "error: version mismatch — .claude-plugin/plugin.json=$VERSION marketplace.json=$MKT .codex-plugin/plugin.json=$CODEX" >&2
  echo "All three must match. Bump them together." >&2
  exit 1
fi

rm -rf dist && mkdir -p dist

# --- Claude ------------------------------------------------------------------
# marketplace.json is deliberately excluded: this is a PLUGIN package, not a
# marketplace. The repo doubles as both; the zip is only ever the former.
CLAUDE_OUT="dist/kowalah-plugin-${VERSION}.zip"
zip -qr "$CLAUDE_OUT" \
  .claude-plugin/plugin.json \
  .mcp.json \
  skills/ \
  README.md \
  LICENSE

# --- OpenAI ------------------------------------------------------------------
# .codex-plugin/plugin.json is the manifest OpenAI reads; .mcp.json is the same
# file Claude uses, and is what Codex connects with. .app.json maps the plugin
# to the MCP app registered in ChatGPT (plugin_asdk_app_…): ChatGPT only uses
# a remote MCP server through a registered app, never through .mcp.json. No .claude-plugin/: with both present OpenAI would have two
# manifests to choose between. No README.md: it is written for Claude users.
OPENAI_OUT="dist/kowalah-plugin-openai-${VERSION}.zip"
EXCLUDES=()
for s in "${CLAUDE_ONLY_SKILLS[@]+"${CLAUDE_ONLY_SKILLS[@]}"}"; do EXCLUDES+=(-x "skills/$s/*"); done
zip -qr "$OPENAI_OUT" \
  .codex-plugin/plugin.json \
  .mcp.json \
  .app.json \
  skills/ \
  assets/ \
  LICENSE \
  ${EXCLUDES[@]+"${EXCLUDES[@]}"}

for out in "$CLAUDE_OUT" "$OPENAI_OUT"; do
  echo "built $out ($(du -h "$out" | cut -f1))"
  unzip -Z1 "$out" | sed 's/^/  /'
done
