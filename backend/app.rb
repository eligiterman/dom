require 'sinatra'
require 'sinatra/json'
require 'dotenv/load'

# Load all our modules
require_relative 'config/api_config'
require_relative 'models/listing'
require_relative 'services/api_client'
require_relative 'services/listing_service'
require_relative 'controllers/listings_controller'

# Main Sinatra application
# This file only contains routes - all configuration is in lib/initializers/

# Load the application initializer
require_relative 'lib/initializers/app'

# Include helpers
helpers ApiHelper

# Initialize controller
listings_controller = ListingsController.new

# Routes
get '/' do
  json success_response(
    message: "Real Estate Listing Aggregator is running!",
    version: "1.0.0",
    endpoints: [
      "GET /listings - Get all listings",
      "GET /listings/search - Search listings",
      "GET /listings/:id - Get specific listing",
      "GET /health - API health check"
    ]
  )
end

get '/listings' do
  result = listings_controller.index
  status result[:status]
  json result[:success] ? success_response(result[:data]) : error_response(result[:data][:error], result[:status])
end

get '/listings/search' do
  # Validate search parameters
  validation_errors = validate_search_params(params)
  if validation_errors.any?
    status 400
    return json error_response(validation_errors.join(', '), 400)
  end
  
  result = listings_controller.search(params)
  status result[:status]
  json result[:success] ? success_response(result[:data]) : error_response(result[:data][:error], result[:status])
end

get '/listings/:id' do
  result = listings_controller.show(params['id'])
  status result[:status]
  json result[:success] ? success_response(result[:data]) : error_response(result[:data][:error], result[:status])
end

get '/health' do
  result = listings_controller.health
  status result[:status]
  json result[:success] ? success_response(result[:data]) : error_response(result[:data][:error], result[:status])
end

# API Documentation endpoint
get '/docs' do
  redirect '/api_docs/index.html'
end

# Fetch real data from APIs (for data viewer)
get '/api/fetch-real-data' do
  content_type :json
  
  begin
    require_relative 'services/real_data_service'
    real_data_service = RealDataService.new
    listings = real_data_service.fetch_all_real_data
    
    # Convert to hash format for frontend
    data = {}
    listings.each do |listing|
      source = listing.source
      data[source] ||= []
      data[source] << listing.attributes
    end
    
    {
      success: true,
      data: data,
      message: "Successfully fetched data from #{data.keys.length} APIs"
    }
  rescue => e
    {
      success: false,
      error: e.message,
      data: {}
    }
  end
end