#!/bin/bash

# Deployment script for Real Estate API
# This script helps prepare the application for deployment

set -e

echo "🚀 Preparing for deployment..."

# Check if we're in the right directory
if [ ! -f "app.rb" ]; then
    echo "❌ Error: app.rb not found. Please run this script from the backend directory."
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running. Please start Docker and try again."
    exit 1
fi

# Build the production image
echo "🔨 Building production Docker image..."
docker build --target production -t real-estate-api:production .

# Test the production image locally
echo "🧪 Testing production image..."
docker run --rm -e RAILS_ENV=production -e RACK_ENV=production real-estate-api:production bundle exec ruby -c app.rb

echo "✅ Production image built and tested successfully!"
echo ""
echo "📋 Next steps for deployment:"
echo "1. Push your code to GitHub:"
echo "   git add ."
echo "   git commit -m 'Fix database configuration for deployment'"
echo "   git push origin main"
echo ""
echo "2. Deploy to Render:"
echo "   - Go to render.com and connect your repository"
echo "   - Set environment variables:"
echo "     - RAPIDAPI_KEY: your_actual_api_key"
echo "     - ENVIRONMENT: production"
echo "     - RAILS_ENV: production"
echo "     - RACK_ENV: production"
echo ""
echo "3. Or deploy to any Docker host:"
echo "   - Push the image to a registry"
echo "   - Deploy using the production image"
echo ""
echo "🎉 Your application is ready for deployment!"
