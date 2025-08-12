# Listing Validator
# Handles validation logic for listing data

class ListingValidator
  def self.validate_search_params(params)
    errors = []
    
    # Validate price ranges
    if params['min_price'] && params['max_price']
      min_price = params['min_price'].to_i
      max_price = params['max_price'].to_i
      if min_price > max_price
        errors << "min_price cannot be greater than max_price"
      end
    end
    
    # Validate bedroom/bathroom ranges
    if params['min_bedrooms'] && params['max_bedrooms']
      min_bedrooms = params['min_bedrooms'].to_i
      max_bedrooms = params['max_bedrooms'].to_i
      if min_bedrooms > max_bedrooms
        errors << "min_bedrooms cannot be greater than max_bedrooms"
      end
    end
    
    # Validate bathroom ranges
    if params['min_bathrooms'] && params['max_bathrooms']
      min_bathrooms = params['min_bathrooms'].to_i
      max_bathrooms = params['max_bathrooms'].to_i
      if min_bathrooms > max_bathrooms
        errors << "min_bathrooms cannot be greater than max_bathrooms"
      end
    end
    
    # Validate numeric values
    ['min_price', 'max_price', 'min_bedrooms', 'max_bedrooms', 'min_bathrooms', 'max_bathrooms'].each do |param|
      if params[param] && !params[param].to_s.match?(/^\d+$/)
        errors << "#{param} must be a valid number"
      end
    end
    
    errors
  end
  
  def self.validate_listing_data(data)
    errors = []
    
    # Required fields
    required_fields = ['address', 'city', 'state']
    required_fields.each do |field|
      if data[field].nil? || data[field].to_s.strip.empty?
        errors << "#{field} is required"
      end
    end
    
    # Numeric validations
    if data['price'] && data['price'].to_f <= 0
      errors << "price must be greater than 0"
    end
    
    if data['bedrooms'] && data['bedrooms'].to_i < 0
      errors << "bedrooms cannot be negative"
    end
    
    if data['bathrooms'] && data['bathrooms'].to_f < 0
      errors << "bathrooms cannot be negative"
    end
    
    if data['square_feet'] && data['square_feet'].to_i <= 0
      errors << "square_feet must be greater than 0"
    end
    
    errors
  end
end 