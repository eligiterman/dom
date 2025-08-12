require_relative '../models/listing'
require_relative 'api_client'

class ListingService
  def initialize
    @api_client = ApiClient.new
    @cache_duration = 300 # 5 minutes
  end

  def get_all_listings
    # Get from database first, then fetch from APIs if needed
    listings = Listing.where(active: true).recent
    
    if listings.empty?
      # Fetch from APIs and store in database
      fetch_and_store_listings
      listings = Listing.where(active: true).recent
    end
    
    listings
  end

  def search_listings(criteria)
    # Use ActiveRecord's search method
    Listing.search(criteria).where(active: true)
  end

  def get_listing_by_id(id)
    Listing.find_by(id: id, active: true)
  end

  def get_api_health
    health_status = {}
    
    ApiConfig.sources.each do |source, config|
      health_status[source] = @api_client.health_check(source, config)
    end
    
    health_status
  end

  def refresh_listings
    # Fetch fresh data from all APIs and update database
    fetch_and_store_listings
  end

  private

  def fetch_and_store_listings
    ApiConfig.sources.each do |source, config|
      begin
        listings_data = @api_client.fetch_listings(source, config)
        
        listings_data.each do |listing_data|
          # Check if listing already exists by external_id
          existing_listing = Listing.find_by(external_id: listing_data.external_id, source: source)
          
          if existing_listing
            # Update existing listing
            existing_listing.update!(
              price: listing_data.price,
              description: listing_data.description,
              images: listing_data.images,
              listing_date: listing_data.listing_date,
              raw_data: listing_data.attributes
            )
          else
            # Create new listing
            Listing.create!(
              address: listing_data.address,
              city: listing_data.city,
              state: listing_data.state,
              zip_code: listing_data.zip_code,
              price: listing_data.price,
              bedrooms: listing_data.bedrooms,
              bathrooms: listing_data.bathrooms,
              square_feet: listing_data.square_feet,
              description: listing_data.description,
              images: listing_data.images,
              source: listing_data.source,
              property_type: listing_data.property_type,
              year_built: listing_data.year_built,
              lot_size: listing_data.lot_size,
              listing_date: listing_data.listing_date,
              external_id: listing_data.external_id,
              raw_data: listing_data.attributes
            )
          end
        end
        
        puts "Updated #{listings_data.length} listings from #{source}"
      rescue => e
        puts "Error fetching from #{source}: #{e.message}"
      end
    end
  end

  def generate_sample_listing(id)
    # For now, return a sample listing if not found in database
    Listing.new({
      id: id,
      address: "123 Sample Street",
      city: "Sample City",
      state: "CA",
      zip_code: "90210",
      price: 500000,
      bedrooms: 3,
      bathrooms: 2,
      square_feet: 1500,
      description: "Beautiful sample property with modern amenities",
      images: ["https://example.com/image1.jpg", "https://example.com/image2.jpg"],
      source: "sample_api",
      property_type: "Single Family",
      year_built: 2010,
      lot_size: 5000,
      listing_date: Date.today,
      external_id: "sample_#{id}"
    })
  end
end 