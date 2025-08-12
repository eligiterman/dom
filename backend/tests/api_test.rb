#!/usr/bin/env ruby

# Comprehensive API Test Script
# Tests RapidAPI connections and falls back to sample data

require 'httparty'
require 'json'
require 'dotenv/load'

class ApiTester
  def initialize
    @rapidapi_key = ENV['RAPIDAPI_KEY']
    @has_valid_key = @rapidapi_key && @rapidapi_key != 'your_rapidapi_key_here'
  end

  def run_comprehensive_test
    puts "🚀 COMPREHENSIVE API TEST"
    puts "=" * 60
    
    if @has_valid_key
      puts "✅ RapidAPI Key found: #{@rapidapi_key[0..10]}..."
      test_rapidapi_apis
    else
      puts "❌ No valid RapidAPI key found"
      puts "   Using sample data instead..."
    end
    
    test_sample_data
    show_next_steps
  end

  def test_rapidapi_apis
    puts "\n🔍 TESTING RAPIDAPI CONNECTIONS"
    puts "-" * 40
    
    apis_to_test = [
      {
        name: "Realty Mole Property API",
        url: "https://realty-mole-property-api.p.rapidapi.com/properties",
        host: "realty-mole-property-api.p.rapidapi.com",
        params: { city: "Los Angeles", state: "CA", limit: 3 }
      },
      {
        name: "RentSpree API",
        url: "https://rentspree.p.rapidapi.com/properties", 
        host: "rentspree.p.rapidapi.com",
        params: { city: "Los Angeles", state: "CA", limit: 3 }
      },
      {
        name: "Zillow API",
        url: "https://zillow56.p.rapidapi.com/search",
        host: "zillow56.p.rapidapi.com", 
        params: { location: "Los Angeles, CA", limit: 3 }
      }
    ]
    
    @working_apis = 0
    
    apis_to_test.each do |api|
      puts "\n🔍 Testing: #{api[:name]}"
      
      headers = {
        'X-RapidAPI-Key' => @rapidapi_key,
        'X-RapidAPI-Host' => api[:host]
      }
      
      begin
        response = HTTParty.get(api[:url], headers: headers, query: api[:params])
        
        case response.code
        when 200
          puts "   ✅ SUCCESS! API is working"
          data = JSON.parse(response.body)
          if data.is_a?(Array) && data.length > 0
            puts "   📊 Found #{data.length} properties"
            data.first(2).each_with_index do |property, index|
              address = property['address'] || property['formattedAddress'] || "Address #{index + 1}"
              price = property['price'] || property['listPrice'] || "Price not available"
              puts "      #{index + 1}. #{address} - $#{price}"
            end
            @working_apis += 1
          elsif data.is_a?(Hash) && data['entries']
            puts "   📊 Found #{data['entries'].length} properties"
            @working_apis += 1
          else
            puts "   ⚠️  No properties found in response"
          end
        when 401
          puts "   ❌ UNAUTHORIZED - Need to subscribe to this API"
          puts "   🔗 Go to RapidAPI and search for '#{api[:name]}'"
        when 403
          puts "   ❌ FORBIDDEN - Need to subscribe to this API"
          puts "   🔗 Go to RapidAPI and search for '#{api[:name]}'"
        when 429
          puts "   ⚠️  RATE LIMITED - Hit monthly limit"
        else
          puts "   ❌ ERROR #{response.code}: #{response.body[0..100]}..."
        end
      rescue => e
        puts "   ❌ ERROR: #{e.message}"
      end
    end
    
    puts "\n📊 SUMMARY: #{@working_apis}/3 APIs working"
  end

  def test_sample_data
    puts "\n🏠 TESTING SAMPLE DATA"
    puts "-" * 40
    
    sample_listings = [
      {
        address: "123 Main St, Los Angeles, CA",
        price: 750000,
        bedrooms: 3,
        bathrooms: 2,
        square_feet: 1800,
        property_type: "Single Family",
        source: "sample_data"
      },
      {
        address: "456 Oak Ave, San Francisco, CA", 
        price: 1200000,
        bedrooms: 4,
        bathrooms: 3,
        square_feet: 2200,
        property_type: "Single Family",
        source: "sample_data"
      },
      {
        address: "789 Pine St, New York, NY",
        price: 950000,
        bedrooms: 2,
        bathrooms: 2,
        square_feet: 1200,
        property_type: "Condo",
        source: "sample_data"
      }
    ]
    
    puts "✅ Sample data ready! #{sample_listings.length} properties available"
    
    sample_listings.each_with_index do |listing, index|
      puts "  #{index + 1}. #{listing[:address]}"
      puts "     Price: $#{listing[:price].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
      puts "     #{listing[:bedrooms]} bed, #{listing[:bathrooms]} bath, #{listing[:square_feet]} sqft"
      puts "     Type: #{listing[:property_type]}"
      puts ""
    end
  end

  def show_next_steps
    puts "=" * 60
    puts "📋 NEXT STEPS"
    puts "=" * 60
    
    if @has_valid_key
      if @working_apis > 0
        puts "🎉 GREAT! You have #{@working_apis} working API(s)"
        puts "🚀 Ready to run your application:"
        puts "   1. bundle install"
        puts "   2. bundle exec ruby app.rb"
        puts "   3. Visit: http://localhost:4000/listings"
      else
        puts "⚠️  No APIs working yet. You can still use sample data:"
        puts "   1. bundle install"
        puts "   2. bundle exec ruby app.rb"
        puts "   3. Visit: http://localhost:4000/listings"
        puts ""
        puts "🔗 To get real data, subscribe to APIs on RapidAPI.com"
      end
    else
      puts "📝 To get real data:"
      puts "   1. Go to https://rapidapi.com/"
      puts "   2. Sign up and get your API key"
      puts "   3. Update .env file with your key"
      puts "   4. Subscribe to Realty Mole, RentSpree, and Zillow APIs"
      puts ""
      puts "🚀 Or run with sample data now:"
      puts "   1. bundle install"
      puts "   2. bundle exec ruby app.rb"
      puts "   3. Visit: http://localhost:4000/listings"
    end
  end
end

# Run the comprehensive test
if __FILE__ == $0
  tester = ApiTester.new
  tester.run_comprehensive_test
end 