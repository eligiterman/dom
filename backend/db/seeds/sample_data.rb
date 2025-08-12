# Sample Data Seeder
# Populates the database with sample real estate listings

class SampleDataSeeder
  def self.seed_listings
    sample_listings = [
      {
        address: "123 Main St",
        city: "Los Angeles",
        state: "CA",
        zip_code: "90210",
        price: 750000,
        bedrooms: 3,
        bathrooms: 2,
        square_feet: 1800,
        description: "Beautiful family home in prime location with modern amenities",
        images: ["https://example.com/image1.jpg", "https://example.com/image2.jpg"],
        source: "sample_data",
        property_type: "Single Family",
        year_built: 2015,
        lot_size: 5000,
        listing_date: Date.today,
        external_id: "sample_1"
      },
      {
        address: "456 Oak Ave",
        city: "San Francisco",
        state: "CA",
        zip_code: "94102",
        price: 1200000,
        bedrooms: 4,
        bathrooms: 3,
        square_feet: 2200,
        description: "Modern home with city views and updated kitchen",
        images: ["https://example.com/image3.jpg", "https://example.com/image4.jpg"],
        source: "sample_data",
        property_type: "Single Family",
        year_built: 2020,
        lot_size: 3000,
        listing_date: Date.today,
        external_id: "sample_2"
      },
      {
        address: "789 Pine St",
        city: "New York",
        state: "NY",
        zip_code: "10001",
        price: 950000,
        bedrooms: 2,
        bathrooms: 2,
        square_feet: 1200,
        description: "Cozy apartment in Manhattan with great amenities",
        images: ["https://example.com/image5.jpg", "https://example.com/image6.jpg"],
        source: "sample_data",
        property_type: "Condo",
        year_built: 2018,
        lot_size: 0,
        listing_date: Date.today,
        external_id: "sample_3"
      },
      {
        address: "321 Elm St",
        city: "Austin",
        state: "TX",
        zip_code: "78701",
        price: 650000,
        bedrooms: 3,
        bathrooms: 2,
        square_feet: 1600,
        description: "Charming home in trendy Austin neighborhood",
        images: ["https://example.com/image7.jpg"],
        source: "sample_data",
        property_type: "Single Family",
        year_built: 2012,
        lot_size: 4000,
        listing_date: Date.today,
        external_id: "sample_4"
      },
      {
        address: "654 Maple Dr",
        city: "Seattle",
        state: "WA",
        zip_code: "98101",
        price: 850000,
        bedrooms: 3,
        bathrooms: 2.5,
        square_feet: 1900,
        description: "Contemporary home with mountain views",
        images: ["https://example.com/image8.jpg", "https://example.com/image9.jpg"],
        source: "sample_data",
        property_type: "Single Family",
        year_built: 2019,
        lot_size: 3500,
        listing_date: Date.today,
        external_id: "sample_5"
      }
    ]

    sample_listings.each do |listing_data|
      # Check if listing already exists
      existing_listing = Listing.find_by(external_id: listing_data[:external_id])
      
      if existing_listing
        puts "Updating existing listing: #{listing_data[:address]}"
        existing_listing.update!(listing_data)
      else
        puts "Creating new listing: #{listing_data[:address]}"
        Listing.create!(listing_data)
      end
    end

    puts "✅ Seeded #{sample_listings.length} sample listings!"
  end

  def self.clear_sample_data
    Listing.where(source: "sample_data").destroy_all
    puts "✅ Cleared all sample data!"
  end

  def self.reset_sample_data
    clear_sample_data
    seed_listings
  end
end 