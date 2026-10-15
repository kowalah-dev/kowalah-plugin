# Kowalah for Microsoft 365 Copilot

A Microsoft 365 Copilot plugin with the same twelve skills and the same Kowalah server
(`https://mcp.kowalah.com/api/mcp`) as the Claude, Codex and Cursor plugins. One package
serves two Copilot surfaces:

| Surface | What it uses |
|---|---|
| **Copilot Chat** | A declarative agent (`declarativeAgent.json`) whose instructions condense the skills, with an MCP action (`ai-plugin.json`) that discovers the Kowalah tools at runtime |
| **Copilot Cowork** | The twelve skills, unchanged (`agentSkills[]`), and the Kowalah connector (`agentConnectors[]`) |

```
appPackage/
  manifest.json           Microsoft 365 app manifest
  declarativeAgent.json   The Copilot Chat agent: description, conversation starters, action
  instruction.txt         The agent's instructions
  ai-plugin.json          The agent's MCP action
  color.png               192x192 colour icon
  outline.png             32x32 outline icon
  skills/                 Not committed: copied from ../skills by scripts/sync-m365-skills.sh
env.dev.template          Copy to env/.env.dev before the first provision
m365agents.yml            Provision and publish steps
wiqd.plugin.json          Work IQ Dev Tools project file
```

## Sign-in

Both surfaces use OAuth dynamic client registration with the Kowalah server, so there is
no client ID or secret to configure. Each person signs in with their work email the first
time they use it, and the email domain places them in their company's Kowalah
organisation.

## Build

You need [Work IQ Dev Tools](https://aka.ms/wiqd/docs) (`wiqd`) on Node 24.15 or later,
and a Microsoft 365 tenant with Copilot licences and custom app upload enabled. Cowork
also needs Copilot Cowork enabled in the tenant.

```bash
./scripts/sync-m365-skills.sh          # from the repo root, before every provision
cd .m365-plugin
mkdir -p env && cp -n env.dev.template env/.env.dev   # first time only
wiqd auth login --interactive
wiqd plugin provision --env dev
wiqd plugin share --env dev --scope users --email you@example.com
```

`provision` refuses a version it has already provisioned. To provision again without
changing the version, run `wiqd plugin delete --env dev --yes` first, then copy the
template back, because delete removes `env/.env.dev`.

Then:

- **Copilot Chat:** open the link `provision` prints and add the agent.
- **Copilot Cowork:** go to **Customize → Plugins → Shared with me** and turn the plugin
  on.

## Limitations

- Chat and Cowork connect separately, so someone who belongs to more than one Kowalah
  organisation can be signed in to a different one in each.
- The Chat agent's instructions condense the skills; Cowork uses the skills in full.
