# Real Estate Listing Aggregator

[![Ruby Version](https://img.shields.io/badge/ruby-3.4+-red.svg)](https://ruby-lang.org/)
[![Sinatra](https://img.shields.io/badge/sinatra-4.1+-green.svg)](http://sinatrarb.com/)
[![PostgreSQL](https://img.shields.io/badge/postgresql-13+-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)

A clean, modular Sinatra-based API service that aggregates real estate listings from multiple sources with PostgreSQL database support.

## 🏗️ Architecture

This project follows a clean, modular architecture with database persistence:

```
services/listing-aggregator/
├── app.rb                          # Routes only (clean!)
├── Gemfile                         # Dependencies
├── Gemfile.lock                    # Locked versions
├── README.md                       # Documentation
├── Rakefile                        # Database tasks
├── env.example                     # Environment template
├── config/
│   ├── api_config.rb              # API configurations
│   └── database.yml               # Database configuration
├── models/
│   └── listing.rb                 # ActiveRecord model
├── services/
│   ├── api_client.rb              # External API handling
│   └── listing_service.rb         # Business logic
├── controllers/
│   └── listings_controller.rb     # Request handling
├── lib/
│   ├── initializers/
│   │   └── app.rb                 # App configuration
│   └── helpers/
│       └── api_helper.rb          # Shared helpers
├── db/
│   └── migrate/
│       └── 001_create_listings.rb # Database migration
└── .env                           # Environment variables (gitignored)
```

## 🚀 Setup

### 1. Install Dependencies
```bash
bundle install
```

### 2. Database Setup

#### Install PostgreSQL
- **Windows**: Download from https://www.postgresql.org/download/windows/
- **macOS**: `brew install postgresql`
- **Linux**: `sudo apt-get install postgresql postgresql-contrib`

#### Create Database
```bash
# Create the database
rake db:create

# Run migrations
rake db:migrate

# Seed with sample data
rake db:seed
```

### 3. Environment Configuration
Copy `env.example` to `.env` and configure:
```bash
cp env.example .env
```

Edit `.env` with your settings:
```env
# Database Configuration
DB_USERNAME=postgres
DB_PASSWORD=your_password_here
DB_HOST=localhost
DB_PORT=5432

# Real Estate API Keys
RAPIDAPI_KEY=your_rapidapi_key_here
PROPERTY_API_KEY=your_property_api_key_here
```

### 4. Start the Server
```bash
bundle exec ruby app.rb
```

The server will start on `http://localhost:4000`

## 📡 API Endpoints

### Health Check
- `GET /` - Server status with API documentation
- `GET /health` - API health check with detailed status

### Listings
- `GET /listings` - Get all listings from database
- `GET /listings/search?city=LosAngeles&state=CA&min_price=300000&max_price=800000` - Search listings
- `GET /listings/:id` - Get specific listing details

## 🗄️ Database Features

### Listing Model
- **ActiveRecord ORM** for database operations
- **Validations** for data integrity
- **Scopes** for common queries
- **Search functionality** with multiple criteria
- **Indexes** for performance optimization

### Database Schema
```sql
CREATE TABLE listings (
  id SERIAL PRIMARY KEY,
  address VARCHAR NOT NULL,
  city VARCHAR NOT NULL,
  state VARCHAR NOT NULL,
  zip_code VARCHAR,
  price DECIMAL(12,2),
  bedrooms INTEGER,
  bathrooms INTEGER,
  square_feet INTEGER,
  description TEXT,
  images TEXT, -- Serialized array
  source VARCHAR,
  property_type VARCHAR,
  year_built INTEGER,
  lot_size INTEGER,
  listing_date DATE,
  external_id VARCHAR,
  raw_data JSONB,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

## 🔧 Database Commands

```bash
# Create database
rake db:create

# Run migrations
rake db:migrate

# Reset database (drop, create, migrate, seed)
rake db:reset

# Seed with sample data
rake db:seed

# Drop database
rake db:drop
```

## 🔄 Data Flow

1. **API Fetching**: External APIs are called via `ApiClient`
2. **Data Processing**: Raw data is parsed and normalized
3. **Database Storage**: Listings are stored/updated in PostgreSQL
4. **Querying**: Fast database queries with indexes
5. **Caching**: Database serves as persistent cache

## 🎯 Benefits of Database Architecture

✅ **Persistence**: Data survives server restarts  
✅ **Performance**: Fast queries with indexes  
✅ **Scalability**: Can handle large datasets  
✅ **Reliability**: ACID compliance  
✅ **Search**: Complex search capabilities  
✅ **History**: Track listing changes over time  

## 📊 Example Usage

```bash
# Get all listings
curl http://localhost:4000/listings

# Search for listings in Los Angeles
curl "http://localhost:4000/listings/search?city=LosAngeles&state=CA&min_price=300000&max_price=800000"

# Get specific listing
curl http://localhost:4000/listings/1

# Check API health
curl http://localhost:4000/health
```

## 🔄 Adding New APIs

1. **Add API configuration** in `config/api_config.rb`:
   ```ruby
   'new_api' => {
     'url' => 'https://api.newservice.com/listings',
     'headers' => {
       'Authorization' => "Bearer #{ENV['NEW_API_KEY']}"
     }
   }
   ```

2. **Add API key** to your `.env` file:
   ```
   NEW_API_KEY=your_new_api_key_here
   ```

3. **The system automatically**:
   - Fetches from the new API
   - Stores data in the database
   - Includes in search results

## 🧪 Testing

```ruby
# Test the Listing model
listing = Listing.create!(
  address: "123 Test St",
  city: "Test City",
  state: "CA",
  price: 500000
)

# Test search
results = Listing.search(city: "Test City")
puts results.count # => 1
```

## 🚀 Next Steps

1. **Authentication**: Add user authentication
2. **Rate Limiting**: Implement API rate limiting
3. **Background Jobs**: Add Sidekiq for async processing
4. **Caching**: Add Redis for additional caching
5. **Monitoring**: Add logging and metrics
6. **API Documentation**: Generate OpenAPI specs

## 🔗 Real Estate APIs to Consider

1. **RapidAPI Real Estate APIs:**
   - Realty Mole Property API
   - Zillow API
   - Realtor.com API

2. **Direct APIs:**
   - MLS APIs (requires membership)
   - Redfin API
   - Trulia API

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

This architecture provides a solid foundation for a production-ready real estate listing aggregator with database persistence! 