# Outline Wiki - Quick Reference Card

## 🚀 Common Commands

All commands run from `C:\outline` in PowerShell.

### Start Outline
```powershell
docker compose up -d
```

### Stop Outline
```powershell
docker compose down
```

### Restart Outline
```powershell
docker compose restart outline
```

### View Logs
```powershell
# All services
docker compose logs -f

# Just Outline
docker compose logs -f outline

# Last 50 lines
docker compose logs --tail 50 outline
```

### Check Status
```powershell
docker compose ps
```

### Update to Latest Version
```powershell
docker compose pull
docker compose up -d
```

---

## 💾 Backup & Restore

### Backup
```powershell
# Stop services first
docker compose down

# Backup database and files
$date = Get-Date -Format "yyyy-MM-dd"
Copy-Item -Recurse data-postgres "C:\Backups\outline-db-$date"
Copy-Item -Recurse data-outline "C:\Backups\outline-files-$date"
Copy-Item .env "C:\Backups\outline-env-$date.txt"

# Start again
docker compose up -d
```

### Restore
```powershell
# Stop services
docker compose down

# Restore from backup
Copy-Item -Recurse "C:\Backups\outline-db-2024-01-15" data-postgres
Copy-Item -Recurse "C:\Backups\outline-files-2024-01-15" data-outline

# Start again
docker compose up -d
```

---

## 🔧 Troubleshooting

### Reset Everything (DANGER - deletes all data!)
```powershell
docker compose down
Remove-Item -Recurse data-postgres, data-redis, data-outline
mkdir data-postgres, data-redis, data-outline
docker compose up -d
```

### Reset Just Redis Cache
```powershell
docker compose stop redis
Remove-Item -Recurse data-redis
mkdir data-redis
docker compose start redis
```

### Access Database Directly
```powershell
docker compose exec postgres psql -U outline -d outline
```

### Check Disk Space Usage
```powershell
Get-ChildItem -Recurse data-* | Measure-Object -Property Length -Sum
```

---

## 📝 Configuration Changes

### After editing .env or docker-compose.yml:
```powershell
docker compose up -d
```
(Docker automatically detects changes and recreates containers)

### Force recreate all containers:
```powershell
docker compose up -d --force-recreate
```

---

## 🌐 Access URLs

- **Web Interface:** `http://YOUR_IP:6875`
- **OIDC Callback:** `http://YOUR_IP:6875/auth/oidc.callback`
- **Health Check:** `http://YOUR_IP:6875/_health`

---

## 📊 Monitoring

### Container Resource Usage
```powershell
docker stats
```

### Database Size
```powershell
docker compose exec postgres psql -U outline -d outline -c "SELECT pg_size_pretty(pg_database_size('outline'));"
```

### Outline Version
```powershell
docker compose exec outline cat package.json | Select-String version
```

---

## 🔒 Security Tips

1. **Change default password** in `.env` (POSTGRES_PASSWORD)
2. **Never commit** `.env` file to version control
3. **Regular backups** - schedule with Windows Task Scheduler
4. **Update regularly** - run `docker compose pull` weekly
5. **Firewall** - only allow port 6875 from trusted networks
6. **HTTPS** - use reverse proxy (nginx/Caddy) for production

---

## 🆘 Getting Help

1. **Check logs:** `docker compose logs -f outline`
2. **Review guide:** Open `WINDOWS_SETUP_GUIDE.md`
3. **Official docs:** https://docs.getoutline.com/
4. **Community:** https://github.com/outline/outline/discussions

---

## 📱 Quick Wins

### Add to Windows Startup (optional)
Create `start-outline.bat`:
```batch
@echo off
cd C:\outline
docker compose up -d
```

Place in: `shell:startup` (Win+R, type this)

### Create Desktop Shortcut
Right-click Desktop → New → Shortcut:
```
http://YOUR_IP:6875
```

---

**Pro Tip:** Bookmark this file in your browser for quick access! 🔖
