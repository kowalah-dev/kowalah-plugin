#!/usr/bin/env bash
# Copy skills/ into the Microsoft 365 Copilot plugin and rebuild its skill list.
#
# Microsoft's packager refuses any skill folder that resolves outside
# appPackage/, so a symlink to ../../skills doesn't work. The copy is
# gitignored: skills/ stays the one source of truth, and this runs before every
# wiqd provision or package. The manifest's agentSkills[] is rewritten from the
# directory listing, so a new skill can't be left out of the Copilot plugin.
set -euo pipefail
cd "$(dirname "$0")/.."

DEST=.m365-plugin/appPackage/skills
rm -rf "$DEST"
mkdir -p "$DEST"
# rsync drops dotfiles (.DS_Store) that would otherwise ride into the package.
rsync -a --exclude '.*' skills/ "$DEST"/

python3 - <<'PY'
import json, os
path = ".m365-plugin/appPackage/manifest.json"
m = json.load(open(path))
skills = sorted(d for d in os.listdir("skills") if os.path.isfile(os.path.join("skills", d, "SKILL.md")))
m["agentSkills"] = [{"folder": f"skills/{s}"} for s in skills]
m["version"] = json.load(open(".claude-plugin/plugin.json"))["version"]
with open(path, "w") as f:
    json.dump(m, f, indent=2, ensure_ascii=False)
    f.write("\n")
print(f"synced {len(skills)} skills into {path} (version {m['version']})")
PY
