class Listing < ActiveRecord::Base
  # Validations
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :price, numericality: { greater_than: 0 }, allow_nil: true
  validates :bedrooms, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :bathrooms, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :square_feet, numericality: { greater_than: 0 }, allow_nil: true

  # Scopes for common queries
  scope :by_city, ->(city) { where("LOWER(city) LIKE ?", "%#{city.downcase}%") }
  scope :by_state, ->(state) { where("LOWER(state) = ?", state.downcase) }
  scope :price_range, ->(min, max) { where(price: min..max) }
  scope :bedrooms_range, ->(min, max) { where(bedrooms: min..max) }
  scope :bathrooms_range, ->(min, max) { where(bathrooms: min..max) }
  scope :by_property_type, ->(type) { where("LOWER(property_type) = ?", type.downcase) }
  scope :recent, -> { order(created_at: :desc) }

  # Serialize images array
  serialize :images, Array

  def price_per_sqft
    return nil unless price && square_feet && square_feet > 0
    (price.to_f / square_feet.to_f).round(2)
  end

  def full_address
    [address, city, state, zip_code].compact.join(', ')
  end

  def matches_criteria?(criteria)
    return true if criteria.empty?
    
    criteria.all? do |key, value|
      case key.to_s
      when 'min_price'
        price && price >= value.to_i
      when 'max_price'
        price && price <= value.to_i
      when 'min_bedrooms'
        bedrooms && bedrooms >= value.to_i
      when 'max_bedrooms'
        bedrooms && bedrooms <= value.to_i
      when 'min_bathrooms'
        bathrooms && bathrooms >= value.to_i
      when 'max_bathrooms'
        bathrooms && bathrooms <= value.to_i
      when 'city'
        city && city.downcase.include?(value.downcase)
      when 'state'
        state && state.downcase == value.downcase
      when 'property_type'
        property_type && property_type.downcase == value.downcase
      else
        true
      end
    end
  end

  def self.search(criteria)
    listings = all
    
    if criteria['city']
      listings = listings.by_city(criteria['city'])
    end
    
    if criteria['state']
      listings = listings.by_state(criteria['state'])
    end
    
    if criteria['min_price'] && criteria['max_price']
      listings = listings.price_range(criteria['min_price'].to_i, criteria['max_price'].to_i)
    elsif criteria['min_price']
      listings = listings.where('price >= ?', criteria['min_price'].to_i)
    elsif criteria['max_price']
      listings = listings.where('price <= ?', criteria['max_price'].to_i)
    end
    
    if criteria['min_bedrooms'] && criteria['max_bedrooms']
      listings = listings.bedrooms_range(criteria['min_bedrooms'].to_i, criteria['max_bedrooms'].to_i)
    elsif criteria['min_bedrooms']
      listings = listings.where('bedrooms >= ?', criteria['min_bedrooms'].to_i)
    elsif criteria['max_bedrooms']
      listings = listings.where('bedrooms <= ?', criteria['max_bedrooms'].to_i)
    end
    
    if criteria['min_bathrooms'] && criteria['max_bathrooms']
      listings = listings.bathrooms_range(criteria['min_bathrooms'].to_i, criteria['max_bathrooms'].to_i)
    elsif criteria['min_bathrooms']
      listings = listings.where('bathrooms >= ?', criteria['min_bathrooms'].to_i)
    elsif criteria['max_bathrooms']
      listings = listings.where('bathrooms <= ?', criteria['max_bathrooms'].to_i)
    end
    
    if criteria['property_type']
      listings = listings.by_property_type(criteria['property_type'])
    end
    
    listings
  end
end 