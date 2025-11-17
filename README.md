# Outline Wiki - Docker Deployment for Windows

**Self-hosted knowledge base for teams** - Simple Docker setup for non-programmers.

---

## 📦 What's Included

This repository contains everything you need to deploy **Outline Wiki** on **Docker Desktop (Windows)**:

- ✅ **No cloud dependencies** - runs entirely on your machine
- ✅ **Local file storage** - no AWS S3 needed
- ✅ **PostgreSQL database** - for all your wiki data
- ✅ **Redis caching** - for fast performance
- ✅ **Generic OIDC** authentication - works with Keycloak, Auth0, Authentik, etc.
- ✅ **Simple HTTP access** - `http://YOUR_IP:6875` (HTTPS optional later)

---

## 🚀 Quick Start

### Option 1: Automated Setup (Recommended)

1. Copy all files to `C:\outline\` on your Windows machine
2. Open PowerShell and navigate to the folder:
   ```powershell
   cd C:\outline
   ```
3. Run the setup script:
   ```powershell
   .\setup.ps1
   ```
4. Follow the prompts and edit `.env` with your settings
5. Start Outline:
   ```powershell
   docker compose up -d
   ```

### Option 2: Manual Setup

Follow the detailed step-by-step guide in **[WINDOWS_SETUP_GUIDE.md](WINDOWS_SETUP_GUIDE.md)**.

---

## 📄 Documentation

| File | Description |
|------|-------------|
| **[WINDOWS_SETUP_GUIDE.md](WINDOWS_SETUP_GUIDE.md)** | Complete installation guide with screenshots and troubleshooting |
| **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** | Common commands and operations cheat sheet |
| **docker-compose.yml** | Main configuration file (containers, networks, volumes) |
| **.env.example** | Template for environment variables (copy to `.env`) |
| **setup.ps1** | Automated setup script for Windows PowerShell |

---

## ⚙️ Configuration Files

### Core Files (required)

1. **docker-compose.yml** - Defines three services:
   - `postgres` - Database (port 5432, internal only)
   - `redis` - Cache (port 6379, internal only)
   - `outline` - Web app (port 6875 → your browser)

2. **.env** - Your secrets and settings (create from `.env.example`):
   - Random secrets for encryption
   - Database password
   - Your Windows IP address
   - OIDC provider credentials

### Generated Folders (auto-created)

- `data-postgres/` - PostgreSQL database files
- `data-redis/` - Redis cache files
- `data-outline/` - Uploaded files and attachments

---

## 🔑 Prerequisites

Before starting, make sure you have:

1. **Docker Desktop for Windows** (download: https://www.docker.com/products/docker-desktop/)
2. **PowerShell** (included with Windows)
3. **OIDC Identity Provider** configured (Keycloak/Auth0/Authentik/etc.)
4. **Your Windows IP address** (run `ipconfig` to find it)

---

## 🎯 After Installation

Once running, you can access Outline at: `http://YOUR_IP:6875`

**First user to sign in becomes the admin!**

### Next Steps

1. **Create collections** - Organize your docs (Engineering, Marketing, HR, etc.)
2. **Write documents** - Markdown + WYSIWYG editor
3. **Build templates** - Standardize recurring docs (meeting notes, RFCs, etc.)
4. **Invite team** - Share via OIDC/Google sign-in
5. **Set permissions** - Control who can view/edit each collection

---

## 🛠️ Common Operations

```powershell
# Start Outline
docker compose up -d

# Stop Outline
docker compose down

# View logs
docker compose logs -f outline

# Check status
docker compose ps

# Update to latest version
docker compose pull && docker compose up -d

# Backup data
docker compose down
Copy-Item -Recurse data-postgres C:\Backups\outline-$(Get-Date -Format yyyy-MM-dd)
```

See **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** for more commands.

---

## 🐛 Troubleshooting

### Container won't start
```powershell
docker compose logs outline
```

### Can't access from browser
- Check Windows Firewall (allow port 6875)
- Verify IP address with `ipconfig`
- Ensure Docker Desktop is running

### OIDC errors
- Verify redirect URI: `http://YOUR_IP:6875/auth/oidc.callback`
- Check `.env` has correct OIDC endpoints
- Confirm `OUTLINE_URL` matches browser address

See full troubleshooting guide in **[WINDOWS_SETUP_GUIDE.md](WINDOWS_SETUP_GUIDE.md#-troubleshooting)**.

---

## 📊 Architecture

```
┌─────────────────────────────────────────────┐
│  Browser: http://YOUR_IP:6875              │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│  outline:3000 (Outline Wiki)                │
│  ├─ /var/lib/outline/data → data-outline/  │
│  └─ connects to postgres + redis            │
└─────────────┬───────────┬───────────────────┘
              │           │
    ┌─────────▼──────┐  ┌▼──────────────────┐
    │  postgres:5432 │  │  redis:6379       │
    │  └─ data-postgres/ │  └─ data-redis/│
    └────────────────┘  └───────────────────┘
```

---

## 🔒 Security Notes

⚠️ **Important:**

- **Never commit** `.env` file (contains secrets)
- **Change default passwords** before going to production
- **Use HTTPS** for external access (add reverse proxy)
- **Regular backups** - database contains all your data
- **Firewall rules** - limit port 6875 to trusted networks

---

## 📚 Resources

- **Official Outline Docs:** https://docs.getoutline.com/
- **Outline GitHub:** https://github.com/outline/outline
- **Environment Variables:** https://github.com/outline/outline/blob/main/.env.sample
- **Docker Image:** https://hub.docker.com/r/outlinewiki/outline

---

## 🤝 Support

1. Check **[WINDOWS_SETUP_GUIDE.md](WINDOWS_SETUP_GUIDE.md)** for detailed instructions
2. Review **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** for common tasks
3. Check logs: `docker compose logs -f outline`
4. Search Outline GitHub issues: https://github.com/outline/outline/issues

---

## 📝 License

This deployment configuration is provided as-is. Outline itself is licensed under the Business Source License (BSL). See https://github.com/outline/outline for details.

---

## ✨ Features You'll Love

- 📱 **Responsive design** - works on desktop, tablet, mobile
- 🔍 **Powerful search** - full-text search across all docs
- 🔗 **Backlinks** - see what links to each page
- 📝 **Markdown + WYSIWYG** - write however you prefer
- 👥 **Real-time collaboration** - like Google Docs
- 🎨 **Customizable** - themes, logos, colors
- 📊 **Templates** - standardize recurring documents
- 🔐 **Granular permissions** - control access per collection
- 📎 **File uploads** - drag & drop images and attachments
- 🌍 **Internationalization** - supports multiple languages

---

**Ready to get started?** → Open **[WINDOWS_SETUP_GUIDE.md](WINDOWS_SETUP_GUIDE.md)** and follow the steps!

**Need quick help?** → Check **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** for common commands.

---

Made with ❤️ for teams who want simple, self-hosted documentation.
