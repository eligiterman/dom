#!/usr/bin/env ruby

require 'dotenv/load'
require 'httparty'
require 'json'

puts "🔍 Quick API Test - Let's see what's happening!"
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

# Test one API to see the actual response
puts "🧪 Testing Realty in US API..."
puts "📡 URL: https://realty-in-us.p.rapidapi.com/properties/v2/list-for-sale"
puts ""

begin
  response = HTTParty.get(
    'https://realty-in-us.p.rapidapi.com/properties/v2/list-for-sale',
    headers: {
      'X-RapidAPI-Key' => api_key,
      'X-RapidAPI-Host' => 'realty-in-us.p.rapidapi.com'
    },
    query: {
      'city' => 'Los Angeles',
      'state_code' => 'CA',
      'limit' => 5,
      'offset' => 0
    },
    timeout: 10
  )
  
  puts "📊 Response Status: #{response.code}"
  puts "📋 Response Headers: #{response.headers['content-type']}"
  puts ""
  
  if response.success?
    puts "✅ Success! Here's what we got:"
    data = JSON.parse(response.body)
    puts "📄 Response type: #{data.class}"
    puts "📊 Data keys: #{data.keys}" if data.is_a?(Hash)
    puts "📈 Array length: #{data.length}" if data.is_a?(Array)
    
    if data.is_a?(Array) && data.length > 0
      puts "🏠 Sample listing:"
      sample = data.first
      puts "   Address: #{sample['address'] || 'N/A'}"
      puts "   Price: $#{sample['price'] || 'N/A'}"
      puts "   Beds: #{sample['bedrooms'] || 'N/A'}"
    end
  else
    puts "❌ Error Response:"
    puts "   Status: #{response.code}"
    puts "   Body: #{response.body[0..200]}..." # First 200 chars
  end
  
rescue => e
  puts "❌ Exception: #{e.message}"
end

puts ""
puts "💡 If you see errors, check:"
puts "   1. Your RapidAPI subscriptions are active"
puts "   2. You're subscribed to the right API plans"
puts "   3. Your API key has the right permissions"
puts ""
puts "🔄 Try running this again in a few hours if subscriptions are new!" 