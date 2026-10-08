#!/usr/bin/env node

import { promises as fs } from "node:fs";
import path from "node:path";
import process from "node:process";

const repoRoot = process.cwd();
const errors = [];
const warnings = [];

const pluginNamePattern = /^[a-z0-9](?:[a-z0-9.-]*[a-z0-9])?$/;

function addError(message) {
  errors.push(message);
}

function addWarning(message) {
  warnings.push(message);
}

async function pathExists(targetPath) {
  try {
    await fs.access(targetPath);
    return true;
  } catch {
    return false;
  }
}

async function readJsonFile(filePath, context) {
  let raw;
  try {
    raw = await fs.readFile(filePath, "utf8");
  } catch {
    addError(`${context} is missing: ${filePath}`);
    return null;
  }

  try {
    return JSON.parse(raw);
  } catch (error) {
    addError(`${context} contains invalid JSON (${filePath}): ${error.message}`);
    return null;
  }
}

function normalizeNewlines(content) {
  return content.replace(/\r\n/g, "\n");
}

function parseFrontmatter(content) {
  const normalized = normalizeNewlines(content);
  if (!normalized.startsWith("---\n")) {
    return null;
  }

  const closingIndex = normalized.indexOf("\n---\n", 4);
  if (closingIndex === -1) {
    return null;
  }

  const frontmatterBlock = normalized.slice(4, closingIndex);
  const fields = {};

  for (const line of frontmatterBlock.split("\n")) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) {
      continue;
    }
    const separator = line.indexOf(":");
    if (separator === -1) {
      continue;
    }
    const key = line.slice(0, separator).trim();
    const value = line.slice(separator + 1).trim();
    fields[key] = value;
  }

  return fields;
}

async function walkFiles(dirPath) {
  const files = [];
  const stack = [dirPath];

  while (stack.length > 0) {
    const current = stack.pop();
    const entries = await fs.readdir(current, { withFileTypes: true });
    for (const entry of entries) {
      const entryPath = path.join(current, entry.name);
      if (entry.isDirectory()) {
        stack.push(entryPath);
      } else if (entry.isFile()) {
        files.push(entryPath);
      }
    }
  }

  return files;
}

function isSafeRelativePath(value) {
  if (typeof value !== "string" || value.length === 0) {
    return false;
  }
  if (value.startsWith("http://") || value.startsWith("https://")) {
    return true;
  }
  if (path.isAbsolute(value)) {
    return false;
  }
  const normalized = path.posix.normalize(value.replace(/\\/g, "/"));
  return !normalized.startsWith("../") && normalized !== "..";
}

async function validateFrontmatterFile(filePath, componentName, requiredKeys) {
  const content = await fs.readFile(filePath, "utf8");
  const parsed = parseFrontmatter(content);
  const relativeFile = path.relative(repoRoot, filePath);

  if (!parsed) {
    addError(`${componentName} file missing YAML frontmatter: ${relativeFile}`);
    return;
  }

  for (const key of requiredKeys) {
    if (!parsed[key] || parsed[key].length === 0) {
      addError(`${componentName} file missing "${key}" in frontmatter: ${relativeFile}`);
    }
  }
}

async function validateComponentFrontmatter(pluginDir) {
  const skillsDir = path.join(pluginDir, "skills");
  if (await pathExists(skillsDir)) {
    const files = await walkFiles(skillsDir);
    for (const file of files) {
      if (path.basename(file) === "SKILL.md") {
        await validateFrontmatterFile(file, "skill", ["name", "description"]);
      }
    }
  }

  const rulesDir = path.join(pluginDir, "rules");
  if (await pathExists(rulesDir)) {
    const files = await walkFiles(rulesDir);
    for (const file of files) {
      const ext = path.extname(file).toLowerCase();
      if (ext === ".md" || ext === ".mdc" || ext === ".markdown") {
        await validateFrontmatterFile(file, "rule", ["description"]);
      }
    }
  }

  const agentsDir = path.join(pluginDir, "agents");
  if (await pathExists(agentsDir)) {
    const files = await walkFiles(agentsDir);
    for (const file of files) {
      const ext = path.extname(file).toLowerCase();
      if (ext === ".md" || ext === ".mdc" || ext === ".markdown") {
        await validateFrontmatterFile(file, "agent", ["name", "description"]);
      }
    }
  }

  const commandsDir = path.join(pluginDir, "commands");
  if (await pathExists(commandsDir)) {
    const files = await walkFiles(commandsDir);
    for (const file of files) {
      const ext = path.extname(file).toLowerCase();
      if (ext === ".md" || ext === ".mdc" || ext === ".markdown" || ext === ".txt") {
        await validateFrontmatterFile(file, "command", ["name", "description"]);
      }
    }
  }
}

async function main() {
  const manifestPath = path.join(repoRoot, ".cursor-plugin", "plugin.json");
  const pluginManifest = await readJsonFile(manifestPath, "Cursor plugin manifest");
  if (!pluginManifest) {
    summarizeAndExit();
    return;
  }

  if (typeof pluginManifest.name !== "string" || !pluginNamePattern.test(pluginManifest.name)) {
    addError(
      '"name" in plugin.json must be lowercase and use only alphanumerics, hyphens, and periods.'
    );
  }

  if (!pluginManifest.description || typeof pluginManifest.description !== "string") {
    addWarning("plugin.json should include a description field.");
  }

  if (!pluginManifest.version || typeof pluginManifest.version !== "string") {
    addWarning("plugin.json should include a version field.");
  }

  if (pluginManifest.logo && typeof pluginManifest.logo === "string") {
    if (!pluginManifest.logo.startsWith("http://") && !pluginManifest.logo.startsWith("https://")) {
      const logoPath = path.join(repoRoot, pluginManifest.logo);
      if (!(await pathExists(logoPath))) {
        addError(`Logo file referenced in plugin.json does not exist: ${pluginManifest.logo}`);
      }
    }
  } else {
    addWarning("plugin.json should include a logo field (relative path or URL).");
  }

  await validateComponentFrontmatter(repoRoot);

  const mcpPath = path.join(repoRoot, "mcp.json");
  const mcpPathDot = path.join(repoRoot, ".mcp.json");
  const mcpExists = await pathExists(mcpPath);
  const mcpDotExists = await pathExists(mcpPathDot);
  
  if (mcpExists || mcpDotExists) {
    const actualPath = mcpExists ? mcpPath : mcpPathDot;
    const mcpConfig = await readJsonFile(actualPath, "MCP config");
    if (mcpConfig && mcpConfig.mcpServers) {
      console.log(`Found MCP config with ${Object.keys(mcpConfig.mcpServers).length} server(s).`);
    }
  } else {
    addWarning("No mcp.json or .mcp.json file found (only needed when using MCP servers).");
  }

  const skillsDir = path.join(repoRoot, "skills");
  if (await pathExists(skillsDir)) {
    const entries = await fs.readdir(skillsDir, { withFileTypes: true });
    const skillCount = entries.filter(e => e.isDirectory()).length;
    console.log(`Found ${skillCount} skill(s) in skills/ directory.`);
  }

  summarizeAndExit();
}

function summarizeAndExit() {
  if (warnings.length > 0) {
    console.log("\nWarnings:");
    for (const warning of warnings) {
      console.log(`- ${warning}`);
    }
  }

  if (errors.length > 0) {
    console.error("\nValidation failed:");
    for (const error of errors) {
      console.error(`- ${error}`);
    }
    process.exit(1);
  }

  console.log("\n✅ Cursor plugin validation passed.");
}

await main();
