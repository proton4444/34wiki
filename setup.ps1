# Outline Wiki - Quick Setup Script for Windows
# Run this in PowerShell from C:\outline

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Outline Wiki - Setup Assistant" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
Write-Host "[1/6] Checking Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "  ✓ Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Docker not found! Please install Docker Desktop and try again." -ForegroundColor Red
    exit 1
}

try {
    $composeVersion = docker compose version
    Write-Host "  ✓ Docker Compose found: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Docker Compose not found!" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Create data directories
Write-Host "[2/6] Creating data directories..." -ForegroundColor Yellow
$directories = @("data-postgres", "data-redis", "data-outline")
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
        Write-Host "  ✓ Created $dir" -ForegroundColor Green
    } else {
        Write-Host "  → $dir already exists" -ForegroundColor Gray
    }
}

Write-Host ""

# Generate secrets
Write-Host "[3/6] Generating secrets..." -ForegroundColor Yellow
Write-Host "  This may take a moment (downloading alpine image)..." -ForegroundColor Gray

try {
    $secretKey = docker run --rm alpine sh -c "apk add --no-cache openssl >/dev/null 2>&1 && openssl rand -hex 32"
    $utilsSecret = docker run --rm alpine sh -c "apk add --no-cache openssl >/dev/null 2>&1 && openssl rand -hex 32"
    Write-Host "  ✓ Generated SECRET_KEY" -ForegroundColor Green
    Write-Host "  ✓ Generated UTILS_SECRET" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to generate secrets!" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Get IP address
Write-Host "[4/6] Detecting your IP address..." -ForegroundColor Yellow
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254.*"} | Select-Object -First 1).IPAddress

if ($ip) {
    Write-Host "  ✓ Detected IP: $ip" -ForegroundColor Green
    Write-Host "  → Outline will be accessible at: http://${ip}:6875" -ForegroundColor Cyan
} else {
    Write-Host "  ⚠ Could not auto-detect IP. You'll need to find it manually." -ForegroundColor Yellow
    Write-Host "  Run: ipconfig" -ForegroundColor Gray
    $ip = "YOUR_IP_ADDRESS"
}

Write-Host ""

# Create .env file
Write-Host "[5/6] Creating .env file..." -ForegroundColor Yellow

if (Test-Path .env) {
    Write-Host "  ⚠ .env already exists! Skipping..." -ForegroundColor Yellow
    Write-Host "  (Delete .env if you want to regenerate it)" -ForegroundColor Gray
} else {
    $envContent = @"
# ============================================
# Outline Configuration - AUTO-GENERATED
# Generated on: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
# ============================================

# ----- Secrets (auto-generated) -----
SECRET_KEY=$secretKey
UTILS_SECRET=$utilsSecret

# ----- Database Password -----
# ⚠ CHANGE THIS to a strong password!
POSTGRES_PASSWORD=CHANGE_ME_STRONG_PASSWORD_HERE

# ----- Outline URL -----
OUTLINE_URL=http://${ip}:6875

# ----- OIDC Configuration -----
# ⚠ Fill these in from your Identity Provider
# Redirect URI must be: http://${ip}:6875/auth/oidc.callback

OIDC_CLIENT_ID=your_oidc_client_id
OIDC_CLIENT_SECRET=your_oidc_client_secret
OIDC_AUTH_URI=https://your-idp.com/protocol/openid-connect/auth
OIDC_TOKEN_URI=https://your-idp.com/protocol/openid-connect/token
OIDC_USERINFO_URI=https://your-idp.com/protocol/openid-connect/userinfo

# ----- Optional: Google OAuth -----
# GOOGLE_CLIENT_ID=
# GOOGLE_CLIENT_SECRET=

# ----- Optional: SMTP -----
# SMTP_HOST=
# SMTP_PORT=587
# SMTP_USERNAME=
# SMTP_PASSWORD=
# SMTP_FROM_EMAIL=
"@

    $envContent | Out-File -FilePath .env -Encoding UTF8
    Write-Host "  ✓ Created .env file" -ForegroundColor Green
}

Write-Host ""

# Next steps
Write-Host "[6/6] Next Steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Edit .env file and configure:" -ForegroundColor White
Write-Host "     • POSTGRES_PASSWORD (change from default!)" -ForegroundColor Gray
Write-Host "     • OIDC settings (client ID, secret, endpoints)" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Set up OIDC redirect URI in your Identity Provider:" -ForegroundColor White
Write-Host "     → http://${ip}:6875/auth/oidc.callback" -ForegroundColor Cyan
Write-Host ""
Write-Host "  3. Start Outline:" -ForegroundColor White
Write-Host "     docker compose up -d" -ForegroundColor Cyan
Write-Host ""
Write-Host "  4. Check status:" -ForegroundColor White
Write-Host "     docker compose ps" -ForegroundColor Cyan
Write-Host ""
Write-Host "  5. Open in browser:" -ForegroundColor White
Write-Host "     http://${ip}:6875" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup complete! Review WINDOWS_SETUP_GUIDE.md for detailed instructions." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
