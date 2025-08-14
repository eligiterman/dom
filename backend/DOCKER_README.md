# Docker Deployment Guide

This guide covers setting up and deploying the Real Estate API using Docker containers, ensuring consistent environments across development and production.

## 🐳 Why Docker?

Docker containers provide several advantages for deployment:

- **Environment Consistency**: Same environment across development, staging, and production
- **Version Isolation**: No conflicts between different software versions
- **Easy Scaling**: Simple horizontal scaling with container orchestration
- **Portability**: Works on any system with Docker installed
- **Dependency Management**: All dependencies are bundled in the container

## 📋 Prerequisites

- Docker Desktop installed and running
- Docker Compose (usually included with Docker Desktop)
- Git (for version control)

## 🚀 Quick Start

### 1. Clone and Navigate
```bash
cd backend
```

### 2. Set Environment Variables
Copy the environment template and configure it:
```bash
# For development
cp env.development .env

# For production
cp env.production .env
```

Edit the `.env` file with your specific values:
```bash
# Required: Your RapidAPI key
RAPIDAPI_KEY=your_actual_rapidapi_key_here

# Optional: Override defaults
PORT=4000
POSTGRES_PASSWORD=your_secure_password
```

### 3. Start Development Environment
```bash
# Using the script (recommended)
./docker-scripts.sh dev

# Or manually
docker-compose up --build
```

### 4. Access Your Application
- **API**: http://localhost:4000
- **Health Check**: http://localhost:4000/health
- **Database**: localhost:5432
- **Redis**: localhost:6379

## 🛠️ Development Workflow

### Using Docker Scripts (Recommended)

The project includes convenient scripts for common operations:

#### Linux/Mac:
```bash
./docker-scripts.sh [command]
```

#### Windows:
```cmd
docker-scripts.bat [command]
```

#### Available Commands:

**Development:**
- `dev` - Start development environment
- `dev-detached` - Start in background
- `dev-stop` - Stop development environment
- `dev-logs` - Show logs

**Production:**
- `prod` - Start production environment
- `prod-detached` - Start production in background

**Database:**
- `db-reset` - Reset database (drop, create, migrate, seed)
- `db-migrate` - Run migrations
- `db-seed` - Seed with sample data

**Utilities:**
- `clean` - Clean up Docker resources
- `logs [service]` - Show logs for specific service
- `shell [service]` - Open shell in container
- `test` - Run tests

### Manual Docker Commands

If you prefer manual commands:

```bash
# Build and start all services
docker-compose up --build

# Start in background
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Reset database
docker-compose down -v
docker-compose up -d postgres
docker-compose exec app bundle exec rake db:create db:migrate db:seed
```

## 🏭 Production Deployment

### 1. Render.com Deployment

The project is configured for easy deployment on Render.com:

#### Automatic Deployment:
1. Connect your GitHub repository to Render
2. Render will automatically detect the `render.yaml` configuration
3. Set your environment variables in Render dashboard:
   - `RAPIDAPI_KEY` (required)
   - `ENVIRONMENT=production`
   - `RAILS_ENV=production`

#### Manual Deployment:
1. Create a new Web Service on Render
2. Set the root directory to `backend`
3. Use the Dockerfile for building
4. Set the start command: `bundle exec ruby app.rb`

### 2. Environment Variables for Production

Create a production environment file:
```bash
cp env.production .env.production
```

Key production variables:
```bash
ENVIRONMENT=production
RAILS_ENV=production
RACK_ENV=production
RAPIDAPI_KEY=your_production_key
DATABASE_URL=postgresql://user:password@host:port/database
```

### 3. Database Setup

The application automatically:
- Creates the database if it doesn't exist
- Runs migrations
- Seeds with initial data

For manual database operations:
```bash
# Create database
docker-compose exec app bundle exec rake db:create

# Run migrations
docker-compose exec app bundle exec rake db:migrate

# Seed data
docker-compose exec app bundle exec rake db:seed
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `ENVIRONMENT` | Environment name | `development` | No |
| `RAILS_ENV` | Rails environment | `development` | No |
| `RACK_ENV` | Rack environment | `development` | No |
| `PORT` | Application port | `4000` | No |
| `RAPIDAPI_KEY` | RapidAPI authentication key | - | **Yes** |
| `POSTGRES_DB` | Database name | `listing_aggregator_development` | No |
| `POSTGRES_USER` | Database user | `postgres` | No |
| `POSTGRES_PASSWORD` | Database password | `password` | No |
| `DATABASE_URL` | Full database URL | Auto-generated | No |

### Docker Compose Services

The setup includes three services:

1. **postgres** - PostgreSQL 15 database
2. **redis** - Redis cache (optional)
3. **app** - Ruby application

### Health Checks

All services include health checks:
- **PostgreSQL**: Checks database connectivity
- **Redis**: Pings Redis server
- **App**: Checks HTTP health endpoint

## 🐛 Troubleshooting

### Common Issues

#### 1. Port Already in Use
```bash
# Check what's using the port
lsof -i :4000

# Kill the process or change the port in .env
PORT=4001
```

#### 2. Database Connection Issues
```bash
# Check if PostgreSQL is running
docker-compose ps

# View database logs
docker-compose logs postgres

# Reset database
./docker-scripts.sh db-reset
```

#### 3. Permission Issues (Linux/Mac)
```bash
# Make scripts executable
chmod +x docker-scripts.sh

# Fix file permissions
sudo chown -R $USER:$USER .
```

#### 4. Windows Path Issues
```bash
# Use Windows-style paths in docker-compose.yml
# Ensure line endings are correct (LF vs CRLF)
```

### Debugging

#### View Service Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f app
docker-compose logs -f postgres
```

#### Access Container Shell
```bash
# App container
docker-compose exec app /bin/bash

# Database container
docker-compose exec postgres psql -U postgres
```

#### Check Service Status
```bash
# Running containers
docker-compose ps

# Resource usage
docker stats
```

## 🔒 Security Considerations

### Production Security

1. **Environment Variables**: Never commit sensitive data to version control
2. **Database Passwords**: Use strong, unique passwords
3. **API Keys**: Rotate API keys regularly
4. **Container Security**: Run containers as non-root users
5. **Network Security**: Use internal Docker networks

### Security Best Practices

```bash
# Use secrets management
docker secret create api_key ./secrets/api_key.txt

# Limit container resources
docker-compose up --memory=512m --cpus=1

# Regular security updates
docker-compose pull
docker-compose build --no-cache
```

## 📊 Monitoring

### Health Checks
- Application: `GET /health`
- Database: Automatic PostgreSQL health checks
- Redis: Automatic Redis ping checks

### Logging
```bash
# Structured logging
docker-compose logs --tail=100 -f

# Log aggregation (for production)
docker-compose logs | grep ERROR
```

## 🚀 Scaling

### Horizontal Scaling
```bash
# Scale the app service
docker-compose up --scale app=3

# Use a load balancer
docker-compose up -d nginx
```

### Resource Limits
```bash
# Set memory and CPU limits
docker-compose up --memory=1g --cpus=2
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Render Documentation](https://render.com/docs)
- [PostgreSQL Docker Image](https://hub.docker.com/_/postgres)

## 🤝 Support

If you encounter issues:

1. Check the troubleshooting section above
2. Review the logs: `docker-compose logs -f`
3. Verify your environment variables
4. Ensure Docker is running and up to date

For additional help, check the main project README or create an issue in the repository.

