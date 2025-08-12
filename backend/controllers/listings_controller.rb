require_relative '../services/listing_service'

class ListingsController
  def initialize
    @listing_service = ListingService.new
  end

  def index
    begin
      listings = @listing_service.get_all_listings
      {
        status: 200,
        success: true,
        data: {
          listings: listings.map(&:to_hash),
          count: listings.length
        }
      }
    rescue => e
      {
        status: 500,
        success: false,
        data: { error: e.message }
      }
    end
  end

  def search(params)
    begin
      criteria = extract_search_criteria(params)
      listings = @listing_service.search_listings(criteria)
      
      {
        status: 200,
        success: true,
        data: {
          listings: listings.map(&:to_hash),
          search_params: criteria,
          count: listings.length
        }
      }
    rescue => e
      {
        status: 500,
        success: false,
        data: { error: e.message }
      }
    end
  end

  def show(id)
    begin
      listing = @listing_service.get_listing_by_id(id)
      
      {
        status: 200,
        success: true,
        data: { listing: listing.to_hash }
      }
    rescue => e
      {
        status: 500,
        success: false,
        data: { error: e.message }
      }
    end
  end

  def health
    begin
      health_status = @listing_service.get_api_health
      
      {
        status: 200,
        success: true,
        data: {
          apis: health_status,
          status: 'running',
          timestamp: Time.now.iso8601
        }
      }
    rescue => e
      {
        status: 500,
        success: false,
        data: { error: e.message }
      }
    end
  end

  private

  def extract_search_criteria(params)
    criteria = {}
    
    ApiConfig.search_filters.each do |filter|
      if params[filter] && !params[filter].empty?
        criteria[filter] = params[filter]
      end
    end
    
    criteria
  end
end 