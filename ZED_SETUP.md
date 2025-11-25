# Zed IDE + Outline Wiki + OpenRouter Integration Guide

This guide walks you through setting up Zed IDE with your local Outline Wiki instance and OpenRouter API for AI-powered code assistance.

## Overview

You'll be configuring three components:
1. **mcp-outline** - MCP server for your Outline Wiki
2. **OpenRouter MCP** - LLM provider for Grok 4.1 via OpenRouter
3. **Zed Settings** - Configuration to tie everything together

---

## Step 1: Prerequisites & Installation

### 1.1 Install Python & UV (for mcp-outline)

**Windows (using Chocolatey or manual):**
```bash
# If you have Chocolatey:
choco install python

# Otherwise download from python.org
# Then install uv for faster package management:
pip install uv
```

**macOS:**
```bash
brew install python@3.11
pip install uv
```

**Linux:**
```bash
sudo apt-get install python3 python3-pip
pip install uv
```

### 1.2 Install Node.js/NPM (for OpenRouter MCP)

Download from https://nodejs.org/ (LTS recommended) or:

**macOS:**
```bash
brew install node
```

**Linux:**
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 1.3 Install MCP Servers Globally

After Python and Node.js are installed, run these commands in your terminal:

```bash
# Install mcp-outline (requires Python/UV)
pip install uv mcp-outline

# Install OpenRouter MCP (requires Node.js/NPM)
npm install -g @heltonteixeira/openrouterai
```

**Verify installations:**
```bash
# Check mcp-outline
which mcp-outline
# or
where mcp-outline  # Windows

# Check OpenRouter MCP
npm list -g @heltonteixeira/openrouterai
```

---

## Step 2: Generate API Keys

### 2.1 Get Your Outline API Key

1. Open your Outline Wiki: **http://192.168.1.117:6875**
2. Log in with your credentials (Test User / password)
3. Go to **Settings** (top right menu)
4. Click on **API Tokens** or **Integrations**
5. Create a new API token with a descriptive name (e.g., "Zed IDE")
6. Copy the token - it will look like: `sk_prod_xxxxxxxxxxxxxxxx`
7. **Save this securely** - you'll need it for Zed config

### 2.2 Get Your OpenRouter API Key

1. Visit https://openrouter.ai
2. Sign up or log in
3. Go to **Settings** → **API Keys**
4. Create a new API key
5. Copy the key - it will look like: `sk-or-v1-xxxxxxxxxxxxxxxx`
6. **Save this securely**

---

## Step 3: Configure Zed IDE

### 3.1 Open Zed Settings

1. Launch **Zed IDE**
2. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac)
3. Type: `zed: open settings file` and press Enter
4. This opens your `settings.json` file

### 3.2 Add MCP Server Configuration

In your `settings.json`, add or update the `"context_servers"` block. Replace the placeholder values with your actual API keys:

```json
{
  // ... your other Zed settings ...

  "context_servers": {
    "outline-wiki": {
      "source": "custom",
      "command": "uvx",
      "args": ["mcp-outline"],
      "env": {
        "OUTLINE_API_KEY": "sk_prod_YOUR_ACTUAL_API_KEY_HERE",
        "OUTLINE_API_URL": "http://192.168.1.117:6875/api"
      }
    },

    "grok-openrouter": {
      "source": "custom",
      "command": "npx",
      "args": [
        "-y",
        "@heltonteixeira/openrouterai"
      ],
      "env": {
        "OPENROUTER_API_KEY": "sk-or-v1-YOUR_ACTUAL_API_KEY_HERE",
        "OPENROUTER_DEFAULT_MODEL": "x-ai/grok-4.1-fast"
      }
    }
  },

  "open_router": {
    "api_key": "sk-or-v1-YOUR_ACTUAL_API_KEY_HERE",
    "default_model": "x-ai/grok-4.1-fast"
  }
}
```

### 3.3 Save & Reload

1. Save the `settings.json` file (`Ctrl+S` / `Cmd+S`)
2. Restart Zed completely (close and reopen)
3. Or press `Ctrl+Shift+P` → `restart language server` if available

---

## Step 4: Verify Setup

### 4.1 Check Context Servers Status

1. Open the **Agent Panel** (usually right sidebar)
2. Click the **Settings Gear Icon**
3. Look for **Context Servers**
4. Both `outline-wiki` and `grok-openrouter` should show a **green indicator dot**
5. If either shows red/error, hover over it to see error details

### 4.2 Test the Integration

In the Agent Panel chat, try a prompt like:

```
Using the outline-wiki tool, list all available documents in my wiki.
Then use grok-openrouter to analyze and summarize the structure.
```

---

## Step 5: Common Issues & Troubleshooting

### Issue: "Command not found: uvx" or "mcp-outline not installed"

**Solution:**
```bash
# Verify installation
pip install --upgrade uv mcp-outline

# If still not working, check Python version
python --version  # Should be 3.8+

# Try running directly
python -m mcp_outline
```

### Issue: "OpenRouter MCP not found" or NPM errors

**Solution:**
```bash
# Reinstall with npm
npm install -g @heltonteixeira/openrouterai

# Verify it's installed
npm list -g @heltonteixeira/openrouterai

# If issues persist, try npx directly
npx @heltonteixeira/openrouterai --version
```

### Issue: "Connection refused" or "Cannot reach Outline"

**Verify your Outline instance is running:**
```bash
# Check Docker containers
docker-compose ps

# Should show outline-app and outline-nginx as "Up"
# If not running:
cd /c/knosso/34wiki
docker-compose up -d
```

**Check the API URL is correct:**
- Internal (from Zed on same machine): `http://localhost:6875/api`
- External (from another machine): `http://192.168.1.117:6875/api`

### Issue: "Invalid API Key" error

**Solution:**
1. Double-check you copied the entire key with no extra spaces
2. Regenerate the key in Outline settings
3. Make sure the key hasn't expired (if your Outline has expiration)

---

## Step 6: Usage Examples

### Example 1: Search Wiki for a Document

```
Using the outline-wiki tool, search for all documents containing the word "architecture"
```

### Example 2: Get Document Content & Analyze

```
Using outline-wiki, fetch the document with the title "Project Phoenix Overview".
Then use grok-openrouter to create a technical summary with key points and action items.
```

### Example 3: Wiki-Assisted Code Generation

```
Using outline-wiki, find any code examples or guidelines in the "API Documentation" section.
Then use grok-openrouter to generate a TypeScript function that follows those guidelines.
```

---

## Useful Links

- **Outline Wiki API Docs**: http://192.168.1.117:6875/developers
- **OpenRouter Models**: https://openrouter.ai/docs/models
- **Zed Documentation**: https://zed.dev/docs
- **MCP Protocol**: https://modelcontextprotocol.io

---

## Security Notes

⚠️ **Important Security Reminders:**

1. **Never commit API keys** to git. Use environment files or Zed's built-in secret management
2. **Keep your API keys private** - treat them like passwords
3. **Rotate keys periodically** for security
4. **Use .gitignore** to exclude sensitive files:
   ```
   .env
   .env.local
   settings.json  # If it contains keys
   ```

---

## Next Steps

After verifying everything works:

1. **Explore MCP capabilities** - Try different commands with your wiki data
2. **Customize your Zed workflow** - Bind keyboard shortcuts to common AI tasks
3. **Create reusable prompts** - Save prompts you use frequently
4. **Integrate with your development** - Use Outline for documentation while coding in Zed

Happy coding! 🚀
