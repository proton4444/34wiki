# 🚀 Outline Wiki - Windows Docker Desktop Setup Guide

**Simple self-hosted Outline deployment for non-programmers**

Access your wiki at: `http://YOUR_IP:6875`

---

## 📋 What You'll Get

- **Outline Wiki** running on Docker Desktop (Windows)
- **PostgreSQL** database for data storage
- **Redis** for caching
- **Local disk storage** (no cloud/S3 needed)
- **Generic OIDC** authentication (works with Keycloak, Auth0, Authentik, etc.)
- Optional **Google OAuth** (add later with HTTPS)

---

## ✅ Prerequisites

1. **Docker Desktop for Windows** installed and running
   - Download from: https://www.docker.com/products/docker-desktop/
   - Make sure the Docker icon in system tray shows "Docker Desktop is running"

2. **PowerShell** (comes with Windows)

3. **Your Windows IP address**
   - Open PowerShell and run: `ipconfig`
   - Look for "IPv4 Address" under your active network adapter
   - Example: `192.168.1.100`

4. **OIDC Provider** (one of these):
   - Keycloak, Auth0, Authentik, Okta, Azure AD, etc.
   - You'll need: Client ID, Client Secret, and three endpoint URLs

---

## 🛠️ Installation Steps

### Step 1: Verify Docker is Working

Open **PowerShell** and run:

```powershell
docker --version
docker compose version
```

Both commands should show version numbers. If not, make sure Docker Desktop is running.

---

### Step 2: Create Project Folder

In PowerShell:

```powershell
# Create main folder
mkdir C:\outline
cd C:\outline

# Create data folders for persistent storage
mkdir data-postgres
mkdir data-redis
mkdir data-outline
```

**What this does:**
- `data-postgres` stores your PostgreSQL database
- `data-redis` stores Redis cache data
- `data-outline` stores uploaded files and attachments

---

### Step 3: Copy Configuration Files

Copy these three files into `C:\outline\`:

1. `docker-compose.yml` (main configuration)
2. `.env.example` (template for your secrets)

---

### Step 4: Generate Random Secrets

Run this command **TWICE** in PowerShell to generate two secure random strings:

```powershell
docker run --rm alpine sh -c "apk add --no-cache openssl >/dev/null && openssl rand -hex 32"
```

**First run output** → Save as `SECRET_KEY`
**Second run output** → Save as `UTILS_SECRET`

Example output:
```
a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456
```

---

### Step 5: Create Your .env File

1. Copy `.env.example` to `.env`:

```powershell
Copy-Item .env.example .env
```

2. Edit `C:\outline\.env` in Notepad and fill in:

```env
# Paste your generated secrets
SECRET_KEY=a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456
UTILS_SECRET=b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef1234567

# Choose a strong database password
POSTGRES_PASSWORD=MyStrongPassword123!

# Your Windows machine IP (from ipconfig)
OUTLINE_URL=http://192.168.1.100:6875

# OIDC settings from your identity provider
OIDC_CLIENT_ID=outline-client
OIDC_CLIENT_SECRET=your-oidc-secret-here
OIDC_AUTH_URI=https://your-idp.com/auth
OIDC_TOKEN_URI=https://your-idp.com/token
OIDC_USERINFO_URI=https://your-idp.com/userinfo
```

**Important:** Make sure `OUTLINE_URL` matches exactly how you'll access Outline in your browser.

---

### Step 6: Configure OIDC Provider

In your OIDC provider (Keycloak/Auth0/Authentik):

1. Create a new **confidential client** (or "application")
2. Set **Redirect URI** to: `http://YOUR_IP:6875/auth/oidc.callback`
   - Example: `http://192.168.1.100:6875/auth/oidc.callback`
3. Enable these scopes: `openid`, `profile`, `email`
4. Copy the **Client ID** and **Client Secret** into your `.env` file

**Provider-specific guides:**

<details>
<summary>Keycloak</summary>

1. Go to your realm → Clients → Create
2. Client ID: `outline`
3. Client Protocol: `openid-connect`
4. Access Type: `confidential`
5. Valid Redirect URIs: `http://YOUR_IP:6875/auth/oidc.callback`
6. Get credentials from the "Credentials" tab

Endpoints (replace `YOUR-KEYCLOAK` and `YOUR-REALM`):
- Auth: `https://YOUR-KEYCLOAK/auth/realms/YOUR-REALM/protocol/openid-connect/auth`
- Token: `https://YOUR-KEYCLOAK/auth/realms/YOUR-REALM/protocol/openid-connect/token`
- Userinfo: `https://YOUR-KEYCLOAK/auth/realms/YOUR-REALM/protocol/openid-connect/userinfo`

</details>

<details>
<summary>Authentik</summary>

1. Applications → Providers → Create (OAuth2/OpenID Provider)
2. Name: `Outline`
3. Authorization flow: `Authorization Code`
4. Redirect URIs: `http://YOUR_IP:6875/auth/oidc.callback`
5. Create application and link provider
6. Copy Client ID and Client Secret

Endpoints:
- Auth: `https://YOUR-AUTHENTIK/application/o/authorize/`
- Token: `https://YOUR-AUTHENTIK/application/o/token/`
- Userinfo: `https://YOUR-AUTHENTIK/application/o/userinfo/`

</details>

<details>
<summary>Auth0</summary>

1. Applications → Create Application → Regular Web Application
2. Settings → Application URIs:
   - Allowed Callback URLs: `http://YOUR_IP:6875/auth/oidc.callback`
3. Copy Domain, Client ID, Client Secret

Endpoints (replace `YOUR-DOMAIN.auth0.com`):
- Auth: `https://YOUR-DOMAIN.auth0.com/authorize`
- Token: `https://YOUR-DOMAIN.auth0.com/oauth/token`
- Userinfo: `https://YOUR-DOMAIN.auth0.com/userinfo`

</details>

---

### Step 7: Start Outline

In PowerShell from `C:\outline`:

```powershell
# Download images
docker compose pull

# Start all containers
docker compose up -d

# Check status (all should show "Up")
docker compose ps
```

**Expected output:**
```
NAME               STATUS          PORTS
outline-app        Up 2 minutes    0.0.0.0:6875->3000/tcp
outline-postgres   Up 2 minutes    5432/tcp
outline-redis      Up 2 minutes    6379/tcp
```

---

### Step 8: Access Outline

Open your browser and go to: `http://YOUR_IP:6875`

You should see the Outline sign-in page with your OIDC provider as an option.

**First Sign-In:**
1. Click "OpenID Connect"
2. You'll be redirected to your OIDC provider
3. Sign in with your credentials
4. You'll be redirected back to Outline
5. The first user becomes the **admin**

---

## 📚 Using Outline

### Core Concepts

- **Collections** = Top-level folders (e.g., "Engineering", "Marketing", "HR")
- **Documents** = Pages within collections (can be nested)
- **Templates** = Reusable document structures
- **Search** = Fast full-text search across everything

### Getting Started

1. **Create your first collection:**
   - Click "New collection" in sidebar
   - Name it (e.g., "Team Wiki")
   - Choose an icon and color

2. **Create a document:**
   - Click "New document" inside your collection
   - Start typing (supports Markdown and WYSIWYG)
   - Organize with headings, lists, tables, code blocks

3. **Create a template:**
   - Go to Settings → Templates → New template
   - Useful for: meeting notes, project specs, onboarding docs
   - Use templates when creating new documents

4. **Invite team members:**
   - Settings → Members → Invite people
   - They'll sign in via your OIDC provider
   - Set permissions per collection (View/Edit/Admin)

5. **Share documents:**
   - Click "Share" button on any document
   - Get a public link (read-only) or invite specific users

---

## 🔧 Maintenance

### View Logs

```powershell
# All logs
docker compose logs -f

# Specific service
docker compose logs -f outline
docker compose logs -f postgres
```

### Stop Outline

```powershell
docker compose down
```

(Data stays safe in `data-*` folders)

### Start Again

```powershell
docker compose up -d
```

### Backup Your Data

```powershell
# Stop containers first
docker compose down

# Copy data folders (replace <DATE> with actual date)
Copy-Item -Recurse C:\outline\data-postgres C:\Backups\outline-postgres-2024-01-15
Copy-Item -Recurse C:\outline\data-outline C:\Backups\outline-files-2024-01-15

# Start again
docker compose up -d
```

### Update Outline

```powershell
docker compose pull
docker compose up -d
```

---

## 🔒 Optional: Add Google OAuth (Later)

Google OAuth **requires HTTPS** on a real domain (not `http://IP`).

**For local testing only** (same PC):
1. Set `OUTLINE_URL=http://localhost:6875` in `.env`
2. In Google Cloud Console, add redirect: `http://localhost:6875/auth/google.callback`
3. Uncomment Google settings in `.env`

**For real deployment:**
1. Set up reverse proxy with HTTPS (nginx/Caddy/Traefik)
2. Get a domain name and SSL certificate
3. Set `OUTLINE_URL=https://wiki.yourcompany.com`
4. Set `FORCE_HTTPS=true` in docker-compose.yml
5. In Google Cloud Console, add redirect: `https://wiki.yourcompany.com/auth/google.callback`

---

## 🐛 Troubleshooting

### Container won't start

```powershell
docker compose logs outline
```

Common issues:
- Missing required env variables in `.env`
- Wrong `OUTLINE_URL` (must match browser URL exactly)
- Database password mismatch

### OIDC "redirect_uri_mismatch" error

- Check that redirect URI in your IdP is **exactly**: `http://YOUR_IP:6875/auth/oidc.callback`
- Check that `OUTLINE_URL` in `.env` matches your browser address bar
- Make sure protocol (http/https) matches everywhere

### Can't access from other computers

- Check Windows Firewall (allow port 6875)
- Verify Docker Desktop network settings
- Confirm you're using the correct IP address from `ipconfig`

### Database connection errors

- Verify `POSTGRES_PASSWORD` is the same in both places in docker-compose.yml
- Check `docker compose logs postgres` for database errors
- Ensure containers are on the same network: `docker network ls`

---

## 📖 Additional Resources

- **Official Outline Docs:** https://docs.getoutline.com/
- **Environment Variables Reference:** https://github.com/outline/outline/blob/main/.env.sample
- **Docker Image:** https://hub.docker.com/r/outlinewiki/outline

---

## 🎯 Next Steps

1. ✅ Customize your workspace (logo, colors in Settings)
2. ✅ Set up collections for your team structure
3. ✅ Create document templates for common workflows
4. ✅ Invite team members
5. ✅ Set up regular backups (schedule with Task Scheduler)
6. 🔒 Move to HTTPS when ready for external access

**Need help?** Check the logs first, then review the troubleshooting section above.

---

**Happy documenting! 📝**
