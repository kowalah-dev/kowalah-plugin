#!/usr/bin/env bash
# Capture the frontmost Google Chrome window as captures/shot-N.png, at full
# Retina resolution, without the window shadow. Usage: ./capture.sh N
# Needs Screen Recording permission for the app running this script.
set -euo pipefail
cd "$(dirname "$0")"
n="${1:?usage: ./capture.sh N (1-5)}"

# The first on-screen, normal-layer Chrome window in the list is the frontmost.
id=$(swift - <<'EOF'
import CoreGraphics
let opts = CGWindowListOption(arrayLiteral: .optionOnScreenOnly, .excludeDesktopElements)
let list = CGWindowListCopyWindowInfo(opts, kCGNullWindowID) as? [[String: Any]] ?? []
let chrome = list.first { ($0["kCGWindowOwnerName"] as? String) == "Google Chrome" && ($0["kCGWindowLayer"] as? Int) == 0
  && ((($0["kCGWindowBounds"] as? [String: Any])?["Width"] as? Double) ?? 0) > 400 }
print(chrome?["kCGWindowNumber"] as? Int ?? 0)
EOF
)
[ "$id" != 0 ] || { echo "No Chrome window found" >&2; exit 1; }

mkdir -p captures
screencapture -x -o -l "$id" "captures/shot-$n.png"
sips -g pixelWidth -g pixelHeight "captures/shot-$n.png" | awk '/pixel/ {printf "%s ", $2}'
echo "-> captures/shot-$n.png"
