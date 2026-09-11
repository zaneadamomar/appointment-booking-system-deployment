$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Appointment Booking System - Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$FrontendRepo = "https://github.com/zaneadamomar/appointment-booking-system-fe.git"
$ApiRepo      = "https://github.com/zaneadamomar/appointment-booking-system-api.git"

$FrontendPath = Join-Path $PSScriptRoot "frontend"
$ApiPath      = Join-Path $PSScriptRoot "api"

# Check Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed." -ForegroundColor Red
    exit 1
}

# Check Docker
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker is not installed." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Cloning application repositories..." -ForegroundColor Yellow

# ============================================================
# FRONTEND
# ============================================================

if (-not (Test-Path $FrontendPath)) {

    Write-Host "Cloning frontend master branch..." -ForegroundColor Yellow

    git clone `
        --branch master `
        --single-branch `
        $FrontendRepo `
        $FrontendPath
}
else {

    Write-Host "Frontend repository already exists." -ForegroundColor Green
    Write-Host "Switching to master and pulling latest changes..." -ForegroundColor Yellow

    git -C $FrontendPath checkout master
    git -C $FrontendPath pull origin master
}

# ============================================================
# API
# ============================================================

if (-not (Test-Path $ApiPath)) {

    Write-Host "Cloning API master branch..." -ForegroundColor Yellow

    git clone `
        --branch master `
        --single-branch `
        $ApiRepo `
        $ApiPath
}
else {

    Write-Host "API repository already exists." -ForegroundColor Green
    Write-Host "Switching to master and pulling latest changes..." -ForegroundColor Yellow

    git -C $ApiPath checkout master
    git -C $ApiPath pull origin master
}

# ============================================================
# ENVIRONMENT
# ============================================================

if (-not (Test-Path (Join-Path $PSScriptRoot ".env"))) {

    Write-Host ""
    Write-Host "ERROR: .env file was not found." -ForegroundColor Red
    Write-Host "Create the .env file before running Docker Compose." -ForegroundColor Red

    exit 1
}

Write-Host ""
Write-Host "Repositories ready." -ForegroundColor Green

# ============================================================
# DOCKER
# ============================================================

Write-Host ""
Write-Host "Starting Docker containers..." -ForegroundColor Cyan
Write-Host ""

docker compose up --build