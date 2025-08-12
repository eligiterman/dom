require 'httparty'
require 'json'
require 'securerandom'

class ApiClient
  include HTTParty
  
  def initialize
    @timeout = 10
    @retries = 3
  end

  def fetch_listings(source, config)
    retries = 0
    begin
      # Prepare request parameters
      request_params = {
        headers: config['headers'],
        timeout: @timeout
      }
      
      # Add query parameters if they exist
      if config['params']
        request_params[:query] = config['params']
      end
      
      response = HTTParty.get(
        config['url'], 
        request_params
      )
      
      if response.success?
        parse_listings(response.body, source)
      else
        puts "Error fetching from #{source}: HTTP #{response.code}"
        []
      end
    rescue => e
      retries += 1
      if retries < @retries
        puts "Retry #{retries} for #{source}: #{e.message}"
        sleep(1)
        retry
      else
        puts "Failed to fetch from #{source} after #{@retries} retries: #{e.message}"
        []
      end
    end
  end

  def health_check(source, config)
    begin
      response = HTTParty.get(
        config['url'], 
        headers: config['headers'],
        timeout: 5
      )
      response.success? ? 'healthy' : 'error'
    rescue => e
      'unavailable'
    end
  end

  private

  def parse_listings(response_body, source)
    data = JSON.parse(response_body)
    
    # Handle different API response formats
    listings = case data
    when Array
      data
    when Hash
      if data['listings']
        data['listings']
      elsif data['properties']
        data['properties']
      elsif data['results']
        data['results']
      else
        [data]
      end
    else
      []
    end

    # Convert to Listing objects and add source
    listings.map do |listing_data|
      listing_data['source'] = source
      listing_data['external_id'] = listing_data['id'] || "#{source}_#{SecureRandom.hex(8)}"
      Listing.new(listing_data)
    end
  end
end 