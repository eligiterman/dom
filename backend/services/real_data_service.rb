# Real Data Service
# Fetches actual listing data from external APIs
# This service is separate from sample data for easy switching

# Load configuration and dependencies
require_relative '../config/api_config'
require_relative 'api_client'

class RealDataService
  def initialize
    @api_client = ApiClient.new
    @config = ApiConfig.sources
  end

  # Main method to fetch real data from all APIs
  def fetch_all_real_data
    puts "🚀 Starting to fetch real data from APIs..."
    puts "📊 Available APIs: #{@config.keys.join(', ')}"
    puts ""

    all_listings = []
    
    @config.each do |api_name, api_config|
      puts "🔍 Fetching from #{api_name.upcase}..."
      
      begin
        listings = fetch_from_api(api_name, api_config)
        all_listings.concat(listings)
        
        puts "✅ #{api_name}: Found #{listings.length} listings"
      rescue => e
        puts "❌ #{api_name}: Error - #{e.message}"
      end
      
      puts ""
    end

    puts "📈 Total real listings fetched: #{all_listings.length}"
    all_listings
  end

  # Fetch data from a specific API
  def fetch_from_api(api_name, api_config)
    puts "   📡 Making request to: #{api_config['url']}"
    puts "   🔑 Using API key: #{mask_api_key(ENV['RAPIDAPI_KEY'])}"
    
    # Check if API key is set
    unless ENV['RAPIDAPI_KEY'] && ENV['RAPIDAPI_KEY'] != 'your_rapidapi_key_here'
      raise "RapidAPI key not configured. Please set RAPIDAPI_KEY in your .env file"
    end

    # Fetch listings from API
    listings = @api_client.fetch_listings(api_name, api_config)
    
    if listings.empty?
      puts "   ⚠️  No listings returned from #{api_name}"
      puts "   💡 This might mean:"
      puts "      - API subscription not active yet"
      puts "      - No properties match the search criteria"
      puts "      - API rate limit reached"
    else
      puts "   🎯 Successfully parsed #{listings.length} listings"
      
      # Show sample of what we got
      if listings.first
        sample = listings.first
        puts "   📝 Sample listing:"
        puts "      Address: #{sample.address}"
        puts "      Price: $#{sample.price}" if sample.price
        puts "      Beds: #{sample.bedrooms}, Baths: #{sample.bathrooms}"
      end
    end

    listings
  end

  # Test API connections without saving data
  def test_api_connections
    puts "🧪 Testing API connections..."
    puts ""

    results = {}
    
    @config.each do |api_name, api_config|
      puts "🔍 Testing #{api_name.upcase}..."
      
      begin
        status = @api_client.health_check(api_name, api_config)
        results[api_name] = status
        
        case status
        when 'healthy'
          puts "   ✅ #{api_name}: Connection successful"
        when 'error'
          puts "   ⚠️  #{api_name}: API returned an error (might be subscription issue)"
        when 'unavailable'
          puts "   ❌ #{api_name}: Connection failed"
        end
      rescue => e
        results[api_name] = 'failed'
        puts "   ❌ #{api_name}: Exception - #{e.message}"
      end
      
      puts ""
    end

    results
  end

  # Save real data to database
  def save_real_data_to_database(listings)
    puts "💾 Saving #{listings.length} real listings to database..."
    
    saved_count = 0
    error_count = 0
    
    listings.each do |listing|
      begin
        # Check if listing already exists
        existing = Listing.find_by(external_id: listing.external_id)
        
        if existing
          # Update existing listing
          existing.update!(
            address: listing.address,
            city: listing.city,
            state: listing.state,
            zip_code: listing.zip_code,
            price: listing.price,
            bedrooms: listing.bedrooms,
            bathrooms: listing.bathrooms,
            square_feet: listing.square_feet,
            description: listing.description,
            images: listing.images,
            property_type: listing.property_type,
            year_built: listing.year_built,
            lot_size: listing.lot_size,
            listing_date: listing.listing_date,
            updated_at: Time.now
          )
          puts "   🔄 Updated: #{listing.address}"
        else
          # Create new listing
          listing.save!
          puts "   ➕ Created: #{listing.address}"
        end
        
        saved_count += 1
      rescue => e
        error_count += 1
        puts "   ❌ Error saving #{listing.address}: #{e.message}"
      end
    end

    puts ""
    puts "📊 Database Update Summary:"
    puts "   ✅ Successfully saved: #{saved_count}"
    puts "   ❌ Errors: #{error_count}"
    puts "   📈 Total listings in database: #{Listing.count}"
  end

  # Clear all real data from database
  def clear_real_data
    puts "🗑️  Clearing all real data from database..."
    
    # Keep sample data, remove only real API data
    real_sources = @config.keys
    deleted_count = Listing.where(source: real_sources).destroy_all.length
    
    puts "   ✅ Deleted #{deleted_count} real listings"
    puts "   📊 Remaining listings: #{Listing.count}"
  end

  # Get database statistics
  def database_stats
    puts "📊 Database Statistics:"
    puts "   📈 Total listings: #{Listing.count}"
    
    @config.keys.each do |source|
      count = Listing.where(source: source).count
      puts "   📋 #{source}: #{count} listings"
    end
    
    sample_count = Listing.where(source: 'sample_data').count
    puts "   🧪 Sample data: #{sample_count} listings"
  end

  private

  # Mask API key for security in logs
  def mask_api_key(key)
    return "NOT_SET" unless key && key != 'your_rapidapi_key_here'
    "#{key[0..7]}...#{key[-4..-1]}"
  end
end 