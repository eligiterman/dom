# Simple Listing class that works without ActiveRecord
# This allows the app to run without a database

class Listing
  attr_accessor :id, :address, :city, :state, :zip_code, :price, :bedrooms, 
                :bathrooms, :square_feet, :description, :images, :source, 
                :property_type, :year_built, :lot_size, :listing_date, 
                :external_id, :raw_data, :active, :created_at, :updated_at

  def initialize(attributes = {})
    @id = attributes[:id] || SecureRandom.uuid
    @address = attributes[:address]
    @city = attributes[:city]
    @state = attributes[:state]
    @zip_code = attributes[:zip_code]
    @price = attributes[:price]
    @bedrooms = attributes[:bedrooms]
    @bathrooms = attributes[:bathrooms]
    @square_feet = attributes[:square_feet]
    @description = attributes[:description]
    @images = attributes[:images] || []
    @source = attributes[:source]
    @property_type = attributes[:property_type]
    @year_built = attributes[:year_built]
    @lot_size = attributes[:lot_size]
    @listing_date = attributes[:listing_date]
    @external_id = attributes[:external_id]
    @raw_data = attributes[:raw_data] || attributes
    @active = attributes[:active] != false
    @created_at = attributes[:created_at] || Time.now
    @updated_at = attributes[:updated_at] || Time.now
  end

  def attributes
    {
      id: @id,
      address: @address,
      city: @city,
      state: @state,
      zip_code: @zip_code,
      price: @price,
      bedrooms: @bedrooms,
      bathrooms: @bathrooms,
      square_feet: @square_feet,
      description: @description,
      images: @images,
      source: @source,
      property_type: @property_type,
      year_built: @year_built,
      lot_size: @lot_size,
      listing_date: @listing_date,
      external_id: @external_id,
      raw_data: @raw_data,
      active: @active,
      created_at: @created_at,
      updated_at: @updated_at
    }
  end

  def to_hash
    attributes
  end

  def save!
    # In-memory storage - just return true
    @updated_at = Time.now
    true
  end

  def update!(attributes)
    attributes.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
    @updated_at = Time.now
    true
  end

  # Class methods for in-memory storage
  @@listings = []

  def self.create!(attributes)
    listing = new(attributes)
    listing.save!
    @@listings << listing
    listing
  end

  def self.find_by(conditions)
    @@listings.find do |listing|
      conditions.all? { |key, value| listing.send(key) == value }
    end
  end

  def self.where(conditions)
    @@listings.select do |listing|
      conditions.all? { |key, value| listing.send(key) == value }
    end
  end

  def self.count
    @@listings.length
  end

  def self.destroy_all
    count = @@listings.length
    @@listings.clear
    count
  end

  # Add some sample data for testing
  def self.create_sample_data
    return unless @@listings.empty?
    
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
        description: "Beautiful modern home in prime location",
        images: ["https://example.com/image1.jpg"],
        source: "sample_data",
        property_type: "Single Family",
        year_built: 2015,
        lot_size: 6000,
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
        description: "Luxury home with stunning city views",
        images: ["https://example.com/image2.jpg"],
        source: "sample_data",
        property_type: "Single Family",
        year_built: 2018,
        lot_size: 4500,
        listing_date: Date.today,
        external_id: "sample_2"
      }
    ]

    sample_listings.each { |attrs| create!(attrs) }
  end

  # Initialize with sample data
  create_sample_data
end 