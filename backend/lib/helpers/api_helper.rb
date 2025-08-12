# API Helper module for common response formatting and validation

module ApiHelper
  def success_response(data, status = 200)
    {
      status: status,
      success: true,
      data: data,
      timestamp: Time.now.iso8601
    }
  end

  def error_response(message, status = 500)
    {
      status: status,
      success: false,
      error: message,
      timestamp: Time.now.iso8601
    }
  end

  def validate_search_params(params)
    require_relative '../validators/listing_validator'
    ListingValidator.validate_search_params(params)
  end

  def paginate_results(listings, page = 1, per_page = 20)
    page = page.to_i
    per_page = per_page.to_i
    
    start_index = (page - 1) * per_page
    end_index = start_index + per_page
    
    {
      listings: listings[start_index...end_index],
      pagination: {
        page: page,
        per_page: per_page,
        total: listings.length,
        total_pages: (listings.length.to_f / per_page).ceil
      }
    }
  end
end 