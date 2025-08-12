#!/usr/bin/env ruby

require 'dotenv/load'
require 'httparty'
require 'json'

puts "🏠 Testing All Your Subscribed APIs"
puts "=" * 50
puts ""

# Check API key
api_key = ENV['RAPIDAPI_KEY']
if api_key && api_key != 'your_rapidapi_key_here'
  puts "✅ API Key found: #{api_key[0..7]}...#{api_key[-4..-1]}"
else
  puts "❌ API Key not configured properly"
  exit 1
end

puts ""

# Define all your APIs
apis = {
  'realty_in_us' => {
    'url' => 'https://realty-in-us.p.rapidapi.com/properties/v2/list-for-sale',
    'host' => 'realty-in-us.p.rapidapi.com',
    'params' => {
      'city' => 'Los Angeles',
      'state_code' => 'CA',
      'limit' => 5,
      'offset' => 0
    }
  },
  'zillow_com1' => {
    'url' => 'https://zillow-com1.p.rapidapi.com/propertyExtendedSearch',
    'host' => 'zillow-com1.p.rapidapi.com',
    'params' => {
      'location' => 'Los Angeles, CA',
      'home_type' => 'Houses',
      'limit' => 5
    }
  },
  'redfin_com_data' => {
    'url' => 'https://redfin-com-data.p.rapidapi.com/property/search',
    'host' => 'redfin-com-data.p.rapidapi.com',
    'params' => {
      'city' => 'Los Angeles',
      'state' => 'CA',
      'limit' => 5
    }
  },

}

# Test each API
results = {}

apis.each do |api_name, config|
  puts "🔍 Testing #{api_name.upcase}..."
  puts "📡 URL: #{config['url']}"
  puts "🏠 Host: #{config['host']}"
  puts ""
  
  begin
    response = HTTParty.get(
      config['url'],
      headers: {
        'X-RapidAPI-Key' => api_key,
        'X-RapidAPI-Host' => config['host']
      },
      query: config['params'],
      timeout: 15
    )
    
    puts "📊 Response Status: #{response.code}"
    puts "📋 Content-Type: #{response.headers['content-type']}"
    puts "📏 Content-Length: #{response.headers['content-length'] || 'N/A'}"
    
    if response.success?
      if response.body.empty?
        puts "✅ Success! (Empty response - this might be normal for some APIs)"
        results[api_name] = 'success_empty'
      else
        begin
          data = JSON.parse(response.body)
          puts "✅ Success! Data received:"
          puts "   📄 Type: #{data.class}"
          
          if data.is_a?(Hash)
            puts "   📊 Keys: #{data.keys.first(5).join(', ')}#{data.keys.length > 5 ? '...' : ''}"
            if data['properties'] || data['listings'] || data['results']
              listings = data['properties'] || data['listings'] || data['results']
              puts "   📈 Listings found: #{listings.length}"
              
              if listings.length > 0
                sample = listings.first
                puts "   🏠 Sample listing:"
                puts "      Address: #{sample['address'] || sample['formattedAddress'] || 'N/A'}"
                puts "      Price: $#{sample['price'] || sample['listPrice'] || 'N/A'}"
                puts "      Beds: #{sample['bedrooms'] || sample['beds'] || 'N/A'}"
              end
            end
          elsif data.is_a?(Array)
            puts "   📈 Array length: #{data.length}"
            if data.length > 0
              sample = data.first
              puts "   🏠 Sample listing:"
              puts "      Address: #{sample['address'] || sample['formattedAddress'] || 'N/A'}"
              puts "      Price: $#{sample['price'] || sample['listPrice'] || 'N/A'}"
              puts "      Beds: #{sample['bedrooms'] || sample['beds'] || 'N/A'}"
            end
          end
          
          results[api_name] = 'success_with_data'
        rescue JSON::ParserError
          puts "⚠️  Success but response is not valid JSON"
          puts "   📄 Response preview: #{response.body[0..100]}..."
          results[api_name] = 'success_invalid_json'
        end
      end
    else
      puts "❌ Error Response:"
      puts "   Status: #{response.code}"
      puts "   Body: #{response.body[0..200]}..."
      results[api_name] = "error_#{response.code}"
    end
    
  rescue => e
    puts "❌ Exception: #{e.message}"
    results[api_name] = 'exception'
  end
  
  puts ""
  puts "-" * 40
  puts ""
end

# Summary
puts "📊 API Test Summary"
puts "=" * 30
results.each do |api, status|
  emoji = case status
  when /^success/
    '✅'
  when /^error_403/
    '🔒'
  when /^error_/
    '⚠️'
  else
    '❌'
  end
  puts "   #{emoji} #{api}: #{status}"
end

puts ""
puts "💡 Status Guide:"
puts "   ✅ success_with_data: API working, data received"
puts "   ✅ success_empty: API working, no data (might be normal)"
puts "   ⚠️  success_invalid_json: API working, but response format unexpected"
puts "   🔒 error_403: Not subscribed or subscription not active"
puts "   ⚠️  error_4xx: API error (check parameters)"
puts "   ❌ exception: Network or other error"
puts ""
puts "🎯 Next Steps:"
puts "   - If you see success_with_data, your APIs are working!"
puts "   - If you see error_403, check your RapidAPI subscriptions"
puts "   - Run 'rake db:save_real_data' to fetch and save real data" 