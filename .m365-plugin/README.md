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
env.dev.template          Copy to env/.env.dev before the first dev provision
env.prod.template         Copy to env/.env.prod before the first prod provision
m365agents.yml            Provision and publish steps
wiqd.plugin.json          Work IQ Dev Tools project file
```

## Sign-in

Both surfaces use OAuth dynamic client registration with the Kowalah server, so there is
no client ID or secret to configure. Each person signs in with their work email the first
time they use it, and the email domain places them in their company's Kowalah
organisation.

The two surfaces register differently:

- **Copilot Chat** uses one auth config, created by the `dcr/register` step in
  `m365agents.yml` when we provision. It lives in Microsoft's token store under the tenant
  that provisioned it, and `ai-plugin.json` points at it by ID. Its `targetAudience` is
  `AnyTenant`, so people in any Microsoft 365 organisation can sign in through it.
  `HomeTenant`, the toolkit's default, would limit sign-in to our own tenant.
- **Copilot Cowork** has no `authorization` block on its connector, so each tenant
  registers its own client with the Kowalah server when someone first connects. Nothing
  to configure.

The trade-off with `AnyTenant`: every client tenant signs in through one auth config that
we own. That is what lets one package work everywhere, but it means:

- Deleting that auth config, or losing access to the tenant that holds it, breaks Copilot
  Chat sign-in for every client at once. Provision `prod` from a tenant we will keep.
- Anyone holding the package can use the auth config. That only gets them to the Kowalah
  sign-in page: `targetUrlsShouldStartWith` limits it to `https://mcp.kowalah.com/api/mcp`,
  and the Kowalah server still decides who gets in and which organisation they see.

`dcr/register` only ever creates an auth config. If the environment file already has
`MCP_DA_AUTH_ID_MCPKOWALAH`, it skips the step and keeps the old setting, so an
environment provisioned before this change stays `HomeTenant` until it is deleted and
provisioned again.

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

## Environments

| Environment | Agent name | Use |
|---|---|---|
| `dev` | Kowalahdev | Testing in our own tenant |
| `prod` | Kowalah | The package we install in client tenants and submit to Partner Center |

`AGENT_NAME` is the only difference in the templates. It names the agent and the Teams app.
An `env/.env.dev` made before it existed needs `AGENT_NAME=Kowalahdev` added; the old
`APP_NAME_SUFFIX` line can go.
Each environment gets its own Teams app ID and its own auth config, so dev and prod can sit
side by side in our tenant.

### Installing in a client's tenant

1. Provision prod once, from our own tenant:

   ```bash
   ./scripts/sync-m365-skills.sh
   cd .m365-plugin
   mkdir -p env && cp -n env.prod.template env/.env.prod   # first time only
   wiqd plugin provision --env prod
   ```

   This creates the Teams app ID and the `AnyTenant` auth config and writes their IDs to
   `env/.env.prod`. Keep that file: every later prod build needs the same IDs. If it is
   lost, provisioning again creates a new auth config, and clients on the old package keep
   working only while the old auth config exists.

2. Build the package:

   ```bash
   set -a; source env/.env.prod; set +a
   wiqd plugin package --env prod --output appPackage/build/kowalah-prod.zip
   wiqd plugin validate --env prod --mode deep --package-file appPackage/build/kowalah-prod.zip
   ```

   `package` (wiqd 0.18) didn't read `env/.env.prod` on its own, hence the `source`. It
   also treats an empty variable as missing, which is why the templates set `AGENT_NAME`
   in full rather than an empty suffix. `--mode deep` runs Microsoft's own store checks
   on the zip.

3. Send the zip to the client's Microsoft 365 admin, who uploads it in the Microsoft 365
   admin centre (**Settings → Integrated apps → Upload custom apps**) and chooses who gets
   it. Their tenant needs Copilot licences, and Copilot Cowork enabled for the skills.

For a new release, bump the version, then repeat steps 2 and 3. Don't provision prod
again unless the manifest's app ID or the auth config needs to change.

## Limitations

- Chat and Cowork connect separately, so someone who belongs to more than one Kowalah
  organisation can be signed in to a different one in each.
- The Chat agent's instructions condense the skills; Cowork uses the skills in full.
