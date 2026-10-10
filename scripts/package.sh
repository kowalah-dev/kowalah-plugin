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

# Options are flags, not environment variables: the Claude plugin directory
# treats a script reading OPENAI_* from the environment as reading a credential.
REVIEW_JSON=""
TEST_APP_ID=""
while [ $# -gt 0 ]; do
  case "$1" in
    --review) REVIEW_JSON="$2"; shift 2 ;;
    --test-app-id) TEST_APP_ID="$2"; shift 2 ;;
    *) echo "usage: $0 [--review path/to/review.json] [--test-app-id plugin_asdk_app_...]" >&2; exit 1 ;;
  esac
done

version_of() { python3 -c "import json,sys;d=json.load(open(sys.argv[1]));print(d['plugins'][0]['version'] if 'plugins' in d else d['version'])" "$1"; }

VERSION=$(version_of .claude-plugin/plugin.json)
MKT=$(version_of .claude-plugin/marketplace.json)
CODEX=$(version_of .codex-plugin/plugin.json)

# Cursor reads this repo directly rather than a zip, but its manifest still has
# to carry the same version. Checked only once it exists.
CURSOR=$VERSION
[ -f .cursor-plugin/plugin.json ] && CURSOR=$(version_of .cursor-plugin/plugin.json)

if [ "$VERSION" != "$MKT" ] || [ "$VERSION" != "$CODEX" ] || [ "$VERSION" != "$CURSOR" ]; then
  echo "error: version mismatch — .claude-plugin/plugin.json=$VERSION marketplace.json=$MKT .codex-plugin/plugin.json=$CODEX .cursor-plugin/plugin.json=$CURSOR" >&2
  echo "They must all match. Bump them together." >&2
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
# file Claude uses. OpenAI's dashboard connects the server from it at submission,
# and the published plugin carries that connection for every user. No .claude-plugin/: with both present OpenAI would have two
# manifests to choose between. No README.md: it is written for Claude users.
OPENAI_OUT="dist/kowalah-plugin-openai-${VERSION}.zip"
EXCLUDES=()
for s in "${CLAUDE_ONLY_SKILLS[@]+"${CLAUDE_ONLY_SKILLS[@]}"}"; do EXCLUDES+=(-x "skills/$s/*"); done
# OpenAI gets its own .mcp.json: the url plus extensions.com.openai.auth
# (OAuth), the shape OpenAI's portal shows for a connectable server. Claude's
# carries "type": "http" and a "note", and the portal offered no Connect for
# it. Same server URL, read from the Claude file. Changing this after a draft
# exists counts as changing the MCP server: the portal then requires a new
# plugin, so settle it before the first upload.
OPENAI_STAGE=$(mktemp -d)
python3 - "$OPENAI_STAGE/.mcp.json" <<'PY'
import json, sys
src = json.load(open(".mcp.json"))["mcpServers"]
json.dump({"mcpServers": {name.lower(): {
    "url": cfg["url"],
    "extensions": {"com.openai": {"auth": {"type": "oauth"}}},
} for name, cfg in src.items()}}, open(sys.argv[1], "w"), indent=2)
PY
zip -qr "$OPENAI_OUT" \
  .codex-plugin/plugin.json \
  skills/ \
  assets/ \
  LICENSE \
  ${EXCLUDES[@]+"${EXCLUDES[@]}"}
# Review material for a directory submission (test cases, demo recording,
# release notes) lives outside this public repo. Pass its JSON with --review
# JSON to merge it under extensions.com.openai in the zip's manifest:
#   ./scripts/package.sh --review ../kowalah-plugin-review/openai/review.json
# Without it the zip has no review block, which suits anything but a submission.
if [ -n "$REVIEW_JSON" ]; then
  mkdir -p "$OPENAI_STAGE/.codex-plugin"
  python3 - "$REVIEW_JSON" "$OPENAI_STAGE/.codex-plugin/plugin.json" <<'PY'
import json, sys
review, out = sys.argv[1], sys.argv[2]
m = json.load(open(".codex-plugin/plugin.json"))
m.setdefault("extensions", {}).setdefault("com.openai", {}).update(json.load(open(review)))
json.dump(m, open(out, "w"), indent=2, ensure_ascii=False)
PY
  zip -qd "$OPENAI_OUT" .codex-plugin/plugin.json >/dev/null
  (cd "$OPENAI_STAGE" && zip -q "$OLDPWD/$OPENAI_OUT" .codex-plugin/plugin.json)
fi
(cd "$OPENAI_STAGE" && zip -q "$OLDPWD/$OPENAI_OUT" .mcp.json)

OUTS=("$CLAUDE_OUT" "$OPENAI_OUT")

# --- OpenAI, private test build ----------------------------------------------
# An uploaded, unpublished plugin has no connection of its own, so ChatGPT shows
# it as available but can't reach the server. For testing in your own account,
# register the server under Plugins > + > Create MCP App, then build with its id:
#   ./scripts/package.sh --test-app-id plugin_asdk_app_...
# This adds .app.json and the manifest's "apps" field to a separate -test zip.
# Never submit it: OpenAI refuses ZIPs with app references.
if [ -n "$TEST_APP_ID" ]; then
  TEST_OUT="dist/kowalah-plugin-openai-${VERSION}-test.zip"
  STAGE=$(mktemp -d)
  cp -R .codex-plugin skills assets LICENSE "$STAGE"/
  cp "$OPENAI_STAGE/.mcp.json" "$STAGE"/
  python3 - "$STAGE" "$TEST_APP_ID" <<'PY'
import json, sys, os
stage, app_id = sys.argv[1], sys.argv[2]
# The URL shows plugin_asdk_app_…; the manifest wants it without "plugin_".
app_id = app_id.removeprefix("plugin_")
json.dump({"apps": {"kowalah": {"id": app_id}}}, open(os.path.join(stage, ".app.json"), "w"), indent=2)
p = os.path.join(stage, ".codex-plugin/plugin.json")
m = json.load(open(p))
m = {**{k: v for k, v in m.items() if k != "mcpServers"}, "apps": "./.app.json", "mcpServers": m["mcpServers"]}
json.dump(m, open(p, "w"), indent=2)
PY
  (cd "$STAGE" && zip -qr - . -x "skills/*/.*") > "$TEST_OUT"
  rm -rf "$STAGE"
  OUTS+=("$TEST_OUT")
fi

rm -rf "$OPENAI_STAGE"

for out in "${OUTS[@]}"; do
  echo "built $out ($(du -h "$out" | cut -f1))"
  unzip -Z1 "$out" | sed 's/^/  /'
done
