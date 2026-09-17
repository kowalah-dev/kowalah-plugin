#!/usr/bin/env bash
# Build the distributable plugin zip for upload to a client's org plugin library.
#
# Why this exists: Anthropic refuses PUBLIC repositories as organization
# marketplaces ("Your repository must be private or internal"). This repo is
# public — deliberately, because the Anthropic plugin directory refuses
# closed-source submissions. The two requirements are mutually exclusive, so a
# client admin who wants this in their org library uploads a zip instead.
#
# Upload replaces by plugin NAME, so re-uploading overwrites the previous
# version with no delete step.
set -euo pipefail
cd "$(dirname "$0")/.."

VERSION=$(python3 -c "import json;print(json.load(open('.claude-plugin/plugin.json'))['version'])")
MKT=$(python3 -c "import json;print(json.load(open('.claude-plugin/marketplace.json'))['plugins'][0]['version'])")

if [ "$VERSION" != "$MKT" ]; then
  echo "error: version mismatch — plugin.json=$VERSION marketplace.json=$MKT" >&2
  echo "Both must match, see RELEASING.md." >&2
  exit 1
fi

OUT="dist/kowalah-plugin-${VERSION}.zip"
rm -rf dist && mkdir -p dist

# marketplace.json is deliberately excluded: this is a PLUGIN package, not a
# marketplace. The repo doubles as both; the zip is only ever the former.
zip -qr "$OUT" \
  .claude-plugin/plugin.json \
  .mcp.json \
  skills/ \
  README.md \
  LICENSE

echo "built $OUT ($(du -h "$OUT" | cut -f1))"
# -n -2 is GNU-only; BSD/macOS head rejects it, so filter with awk instead.
unzip -Z1 "$OUT" | sed 's/^/  /'
