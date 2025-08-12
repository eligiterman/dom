# Real Estate Listing Aggregator

[![Ruby Version](https://img.shields.io/badge/ruby-3.4+-red.svg)](https://ruby-lang.org/)
[![Sinatra](https://img.shields.io/badge/sinatra-4.1+-green.svg)](http://sinatrarb.com/)
[![PostgreSQL](https://img.shields.io/badge/postgresql-13+-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)

A comprehensive real estate listing aggregator that pulls data from multiple APIs and provides a clean, searchable interface.

## 🏗️ Project Structure

```
Dom/
├── backend/                    # Ruby/Sinatra API server
│   ├── app.rb                 # Main application
│   ├── models/                # Database models
│   ├── controllers/           # API endpoints
│   ├── services/              # Business logic
│   ├── config/                # Configuration files
│   ├── lib/                   # Shared utilities
│   ├── db/                    # Database files
│   └── tests/                 # Test files
├── frontend/                  # HTML/CSS/JavaScript
│   ├── index.html             # Main page
│   ├── styles.css             # Styling
│   └── script.js              # Frontend logic
├── shared/                    # Shared between frontend/backend
├── scripts/                   # Utility scripts
├── docs/                      # Documentation
└── .github/                   # CI/CD workflows
```

## 🚀 Quick Start

### Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Install dependencies:**
   ```bash
   bundle install
   ```

3. **Set up environment:**
   ```bash
   cp env.example .env
   # Edit .env with your API keys
   ```

4. **Set up database:**
   ```bash
   rake db:create
   rake db:migrate
   rake db:seed
   ```

5. **Start the server:**
   ```bash
   bundle exec ruby app.rb
   ```

6. **Visit the API:**
   - Main API: http://localhost:4000
   - Listings: http://localhost:4000/listings
   - Health check: http://localhost:4000/health

### Frontend Setup

1. **Navigate to frontend directory:**
   ```bash
   cd frontend
   ```

2. **Open in browser:**
   ```bash
   # Simply open index.html in your browser
   # Or use a local server:
   python -m http.server 8000
   ```

3. **Visit the frontend:**
   - http://localhost:8000 (if using Python server)
   - Or open `frontend/index.html` directly

## 📡 API Endpoints

### Core Endpoints
- `GET /` - API status and documentation
- `GET /health` - Health check
- `GET /listings` - Get all listings
- `GET /listings/search` - Search listings with filters
- `GET /listings/:id` - Get specific listing

### Search Parameters
- `city` - City name
- `state` - State abbreviation
- `min_price` / `max_price` - Price range
- `min_bedrooms` / `max_bedrooms` - Bedroom range
- `min_bathrooms` / `max_bathrooms` - Bathroom range
- `property_type` - Property type (Single Family, Condo, etc.)

### Example Search
```
GET /listings/search?city=LosAngeles&state=CA&min_price=300000&max_price=800000
```

## 🗄️ Database Commands

```bash
# Create database
rake db:create

# Run migrations
rake db:migrate

# Seed with sample data
rake db:seed

# Clear sample data
rake db:clear_sample

# Reset sample data
rake db:reset_sample

# Drop database
rake db:drop
```

## 🧪 Testing

```bash
# Test API connections
ruby tests/api_test.rb

# Run all tests (when implemented)
bundle exec rspec
```

## 🔧 Development

### Adding New Models
1. Create model file in `backend/models/`
2. Create migration in `backend/db/migrate/`
3. Add controller in `backend/controllers/`
4. Add service in `backend/services/`

### Adding New APIs
1. Update `backend/config/api_config.rb`
2. Add API client logic in `backend/services/api_client.rb`
3. Test with `ruby tests/api_test.rb`

### Frontend Development
1. Edit files in `frontend/`
2. Test with local server
3. Update API calls in `script.js`

## 📚 Documentation

- [Backend Documentation](backend/docs/)
- [API Documentation](docs/api_documentation.md)
- [Architecture Guide](docs/architecture.md)
- [Development Summary](backend/docs/development_summary.md)

## 🔗 External APIs

The system integrates with:
- **Realty Mole Property API** - For sale properties
- **RentSpree API** - Rental properties
- **Zillow API** - Zillow data

Get API keys from [RapidAPI](https://rapidapi.com/)

## 🚀 Deployment

### Backend Deployment
- Deploy to Heroku, AWS, or similar
- Set environment variables
- Run database migrations

### Frontend Deployment
- Deploy static files to CDN
- Update API endpoint URLs
- Configure CORS if needed

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- Check the [documentation](docs/)
- Review [development summary](backend/docs/development_summary.md)
- Open an issue for bugs
- Submit feature requests

---

**Built with ❤️ using Ruby, Sinatra, and PostgreSQL** 