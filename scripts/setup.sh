#!/bin/bash

# Real Estate Listing Aggregator Setup Script
# This script sets up the development environment

echo "🚀 Setting up Real Estate Listing Aggregator..."

# Check if Ruby is installed
if ! command -v ruby &> /dev/null; then
    echo "❌ Ruby is not installed. Please install Ruby 3.4+ first."
    exit 1
fi

echo "✅ Ruby found: $(ruby --version)"

# Check if Bundler is installed
if ! command -v bundle &> /dev/null; then
    echo "❌ Bundler is not installed. Installing..."
    gem install bundler
fi

echo "✅ Bundler found: $(bundle --version)"

# Navigate to backend directory
cd backend

# Install Ruby dependencies
echo "📦 Installing Ruby dependencies..."
bundle install

# Set up environment file
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp env.example .env
    echo "⚠️  Please edit .env file with your API keys"
else
    echo "✅ .env file already exists"
fi

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "⚠️  PostgreSQL not found. Please install PostgreSQL:"
    echo "   - Windows: https://www.postgresql.org/download/windows/"
    echo "   - macOS: brew install postgresql"
    echo "   - Linux: sudo apt-get install postgresql postgresql-contrib"
    echo ""
    echo "After installing PostgreSQL, run:"
    echo "  cd backend"
    echo "  rake db:create"
    echo "  rake db:migrate"
    echo "  rake db:seed"
else
    echo "✅ PostgreSQL found: $(psql --version)"
    
    # Set up database
    echo "🗄️  Setting up database..."
    rake db:create
    rake db:migrate
    rake db:seed
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit backend/.env with your API keys"
echo "2. Start the backend server:"
echo "   cd backend"
echo "   bundle exec ruby app.rb"
echo "3. Open frontend/index.html in your browser"
echo ""
echo "API will be available at: http://localhost:4000" 