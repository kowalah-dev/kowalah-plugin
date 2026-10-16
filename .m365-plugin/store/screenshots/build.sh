#!/usr/bin/env bash
# Render the five Partner Center listing screenshots (1366 x 768 PNG) from
# frame.html. Captures go in captures/shot-N.png first; a missing capture
# renders as a labelled placeholder. Output: out/screenshot-N.png.
set -euo pipefail
cd "$(dirname "$0")"

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
mkdir -p out

for n in 1 2 3 4 5; do
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --allow-file-access-from-files --force-device-scale-factor=1 \
    --window-size=1366,768 --virtual-time-budget=4000 \
    --screenshot="$PWD/out/screenshot-$n.png" \
    "file://$PWD/frame.html?shot=$n" >/dev/null 2>&1
  size=$(stat -f%z "out/screenshot-$n.png")
  dims=$(sips -g pixelWidth -g pixelHeight "out/screenshot-$n.png" | awk '/pixel/ {printf "%s ", $2}')
  echo "screenshot-$n.png  ${dims% }  $((size / 1024)) KB"
  # Partner Center's limit is 1,024 KB per screenshot.
  [ "$size" -le 1048576 ] || echo "  over 1,024 KB: export the capture smaller" >&2
done
