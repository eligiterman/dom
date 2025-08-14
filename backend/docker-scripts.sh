#!/bin/bash

# Docker Scripts for Real Estate API
# Usage: ./docker-scripts.sh [command]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to load environment variables
load_env() {
    local env_file="env.${1:-development}"
    if [ -f "$env_file" ]; then
        print_status "Loading environment from $env_file"
        export $(cat "$env_file" | grep -v '^#' | xargs)
    else
        print_warning "Environment file $env_file not found, using defaults"
    fi
}

# Development commands
dev() {
    print_status "Starting development environment..."
    load_env "development"
    docker-compose up --build
}

dev_detached() {
    print_status "Starting development environment in background..."
    load_env "development"
    docker-compose up -d --build
}

dev_stop() {
    print_status "Stopping development environment..."
    docker-compose down
}

dev_logs() {
    print_status "Showing logs..."
    docker-compose logs -f
}

# Production commands
prod() {
    print_status "Starting production environment..."
    load_env "production"
    BUILD_TARGET=production docker-compose up --build
}

prod_detached() {
    print_status "Starting production environment in background..."
    load_env "production"
    BUILD_TARGET=production docker-compose up -d --build
}

# Database commands
db_reset() {
    print_status "Resetting database..."
    docker-compose down -v
    docker-compose up -d postgres
    sleep 5
    docker-compose exec app bundle exec rake db:create db:migrate db:seed
}

db_migrate() {
    print_status "Running database migrations..."
    docker-compose exec app bundle exec rake db:migrate
}

db_seed() {
    print_status "Seeding database..."
    docker-compose exec app bundle exec rake db:seed
}

# Utility commands
clean() {
    print_status "Cleaning up Docker resources..."
    docker-compose down -v --remove-orphans
    docker system prune -f
}

logs() {
    local service=${1:-app}
    print_status "Showing logs for $service..."
    docker-compose logs -f $service
}

shell() {
    local service=${1:-app}
    print_status "Opening shell in $service container..."
    docker-compose exec $service /bin/bash
}

test() {
    print_status "Running tests..."
    docker-compose exec app bundle exec ruby tests/api_test.rb
}

# Main command handler
case "${1:-help}" in
    "dev")
        check_docker
        dev
        ;;
    "dev-detached")
        check_docker
        dev_detached
        ;;
    "dev-stop")
        dev_stop
        ;;
    "dev-logs")
        dev_logs
        ;;
    "prod")
        check_docker
        prod
        ;;
    "prod-detached")
        check_docker
        prod_detached
        ;;
    "db-reset")
        check_docker
        db_reset
        ;;
    "db-migrate")
        check_docker
        db_migrate
        ;;
    "db-seed")
        check_docker
        db_seed
        ;;
    "clean")
        clean
        ;;
    "logs")
        logs $2
        ;;
    "shell")
        shell $2
        ;;
    "test")
        check_docker
        test
        ;;
    "help"|*)
        echo "Docker Scripts for Real Estate API"
        echo ""
        echo "Usage: ./docker-scripts.sh [command]"
        echo ""
        echo "Development Commands:"
        echo "  dev              Start development environment"
        echo "  dev-detached     Start development environment in background"
        echo "  dev-stop         Stop development environment"
        echo "  dev-logs         Show development logs"
        echo ""
        echo "Production Commands:"
        echo "  prod             Start production environment"
        echo "  prod-detached    Start production environment in background"
        echo ""
        echo "Database Commands:"
        echo "  db-reset         Reset database (drop, create, migrate, seed)"
        echo "  db-migrate       Run database migrations"
        echo "  db-seed          Seed database with sample data"
        echo ""
        echo "Utility Commands:"
        echo "  clean            Clean up Docker resources"
        echo "  logs [service]   Show logs for specific service (default: app)"
        echo "  shell [service]  Open shell in container (default: app)"
        echo "  test             Run tests"
        echo "  help             Show this help message"
        ;;
esac

