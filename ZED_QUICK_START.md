# Zed + Outline Wiki Quick Start (TL;DR)

## 1️⃣ Install Requirements

```bash
pip install uv mcp-outline
npm install -g @heltonteixeira/openrouterai
```

## 2️⃣ Get API Keys

| Service | Where to Get | Looks Like |
|---------|-------------|-----------|
| **Outline** | http://192.168.1.117:6875 → Settings → API Tokens | `sk_prod_xxx` |
| **OpenRouter** | https://openrouter.ai → Settings → API Keys | `sk-or-v1-xxx` |

## 3️⃣ Configure Zed

Open Zed → `Ctrl+Shift+P` → `zed: open settings file`

Paste this (replace `XXX` with your actual keys):

```json
{
  "context_servers": {
    "outline-wiki": {
      "source": "custom",
      "command": "uvx",
      "args": ["mcp-outline"],
      "env": {
        "OUTLINE_API_KEY": "sk_prod_XXX",
        "OUTLINE_API_URL": "http://192.168.1.117:6875/api"
      }
    },
    "grok-openrouter": {
      "source": "custom",
      "command": "npx",
      "args": ["-y", "@heltonteixeira/openrouterai"],
      "env": {
        "OPENROUTER_API_KEY": "sk-or-v1-XXX",
        "OPENROUTER_DEFAULT_MODEL": "x-ai/grok-4.1-fast"
      }
    }
  },
  "open_router": {
    "api_key": "sk-or-v1-XXX",
    "default_model": "x-ai/grok-4.1-fast"
  }
}
```

## 4️⃣ Verify It Works

1. Restart Zed
2. Open Agent Panel (right sidebar)
3. Click Settings ⚙️
4. Check "Context Servers" - should see green dots
5. Type a test prompt in the chat

## 5️⃣ Example Prompts

```
Using outline-wiki, list all documents
```

```
Using outline-wiki, find "Project Name" document. 
Then use grok-openrouter to summarize it.
```

```
Using outline-wiki, search for API documentation.
Then generate example code based on the guidelines.
```

## ⚠️ Common Issues

| Problem | Solution |
|---------|----------|
| `uvx` not found | `pip install --upgrade uv` |
| NPM not found | Install Node.js from nodejs.org |
| API Key invalid | Regenerate in Outline/OpenRouter settings |
| Can't reach Outline | Check `docker-compose ps` - services running? |
| Green dots missing | Restart Zed, check terminal for error logs |

## 📚 Full Guide

See `ZED_SETUP.md` for detailed instructions and troubleshooting.

---

**Your Outline URL:** `http://192.168.1.117:6875`

**OpenRouter:** `https://openrouter.ai`

**Zed Docs:** `https://zed.dev/docs`
