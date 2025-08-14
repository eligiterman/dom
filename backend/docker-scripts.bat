@echo off
setlocal enabledelayedexpansion

REM Docker Scripts for Real Estate API (Windows)
REM Usage: docker-scripts.bat [command]

set "COMMAND=%1"
if "%COMMAND%"=="" set "COMMAND=help"

REM Development commands
if "%COMMAND%"=="dev" (
    echo [INFO] Starting development environment...
    docker-compose up --build
    goto :eof
)

if "%COMMAND%"=="dev-detached" (
    echo [INFO] Starting development environment in background...
    docker-compose up -d --build
    goto :eof
)

if "%COMMAND%"=="dev-stop" (
    echo [INFO] Stopping development environment...
    docker-compose down
    goto :eof
)

if "%COMMAND%"=="dev-logs" (
    echo [INFO] Showing logs...
    docker-compose logs -f
    goto :eof
)

REM Production commands
if "%COMMAND%"=="prod" (
    echo [INFO] Starting production environment...
    set "BUILD_TARGET=production"
    docker-compose up --build
    goto :eof
)

if "%COMMAND%"=="prod-detached" (
    echo [INFO] Starting production environment in background...
    set "BUILD_TARGET=production"
    docker-compose up -d --build
    goto :eof
)

REM Database commands
if "%COMMAND%"=="db-reset" (
    echo [INFO] Resetting database...
    docker-compose down -v
    docker-compose up -d postgres
    timeout /t 5 /nobreak >nul
    docker-compose exec app bundle exec rake db:create db:migrate db:seed
    goto :eof
)

if "%COMMAND%"=="db-migrate" (
    echo [INFO] Running database migrations...
    docker-compose exec app bundle exec rake db:migrate
    goto :eof
)

if "%COMMAND%"=="db-seed" (
    echo [INFO] Seeding database...
    docker-compose exec app bundle exec rake db:seed
    goto :eof
)

REM Utility commands
if "%COMMAND%"=="clean" (
    echo [INFO] Cleaning up Docker resources...
    docker-compose down -v --remove-orphans
    docker system prune -f
    goto :eof
)

if "%COMMAND%"=="logs" (
    set "SERVICE=%2"
    if "!SERVICE!"=="" set "SERVICE=app"
    echo [INFO] Showing logs for !SERVICE!...
    docker-compose logs -f !SERVICE!
    goto :eof
)

if "%COMMAND%"=="shell" (
    set "SERVICE=%2"
    if "!SERVICE!"=="" set "SERVICE=app"
    echo [INFO] Opening shell in !SERVICE! container...
    docker-compose exec !SERVICE! /bin/bash
    goto :eof
)

if "%COMMAND%"=="test" (
    echo [INFO] Running tests...
    docker-compose exec app bundle exec ruby tests/api_test.rb
    goto :eof
)

REM Help command
if "%COMMAND%"=="help" (
    echo Docker Scripts for Real Estate API
    echo.
    echo Usage: docker-scripts.bat [command]
    echo.
    echo Development Commands:
    echo   dev              Start development environment
    echo   dev-detached     Start development environment in background
    echo   dev-stop         Stop development environment
    echo   dev-logs         Show development logs
    echo.
    echo Production Commands:
    echo   prod             Start production environment
    echo   prod-detached    Start production environment in background
    echo.
    echo Database Commands:
    echo   db-reset         Reset database (drop, create, migrate, seed)
    echo   db-migrate       Run database migrations
    echo   db-seed          Seed database with sample data
    echo.
    echo Utility Commands:
    echo   clean            Clean up Docker resources
    echo   logs [service]   Show logs for specific service (default: app)
    echo   shell [service]  Open shell in container (default: app)
    echo   test             Run tests
    echo   help             Show this help message
    goto :eof
)

REM Unknown command
echo [ERROR] Unknown command: %COMMAND%
echo.
echo Run 'docker-scripts.bat help' for available commands.
exit /b 1

