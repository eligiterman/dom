#!/usr/bin/env ruby

# Real Data Test Script
# This script helps you test your API connections and fetch real data
# Run this to see if your RapidAPI subscriptions are working

require 'dotenv/load'
require_relative 'lib/initializers/app'
require_relative 'services/real_data_service'

puts "🏠 Real Estate Listing Aggregator - API Test"
puts "=" * 50
puts ""



# Check if we're in the right directory
unless File.exist?('.env')
  puts "❌ Error: .env file not found!"
  puts "💡 Make sure you're running this from the backend directory"
  puts "💡 And that you've copied env.example to .env"
  exit 1
end

# Check if API key is set
unless ENV['RAPIDAPI_KEY'] && ENV['RAPIDAPI_KEY'] != 'your_rapidapi_key_here'
  puts "❌ Error: RapidAPI key not configured!"
  puts "💡 Please edit your .env file and set your RAPIDAPI_KEY"
  puts "💡 Get your key from: https://rapidapi.com/"
  exit 1
end

puts "✅ Environment looks good!"
puts "🔑 API Key: #{ENV['RAPIDAPI_KEY'][0..7]}...#{ENV['RAPIDAPI_KEY'][-4..-1]}"
puts ""

# Initialize the real data service
real_data_service = RealDataService.new

# Step 1: Test API connections
puts "Step 1: Testing API Connections"
puts "-" * 30
results = real_data_service.test_api_connections

puts ""
puts "Connection Test Results:"
results.each do |api, status|
  status_emoji = case status
  when 'healthy' then '✅'
  when 'error' then '⚠️'
  when 'unavailable', 'failed' then '❌'
  end
  puts "   #{status_emoji} #{api}: #{status}"
end

puts ""
puts "💡 If you see 'error' status, your subscription might not be active yet"
puts "💡 If you see 'unavailable', check your internet connection"
puts ""

# Ask user if they want to continue
print "Continue with fetching real data? (y/n): "
response = gets.chomp.downcase

if response != 'y'
  puts "👋 Test completed. Run this script again when your subscriptions are active!"
  exit 0
end

puts ""
puts "Step 2: Fetching Real Data"
puts "-" * 30

# Step 2: Fetch real data
begin
  listings = real_data_service.fetch_all_real_data
  
  if listings.empty?
    puts ""
    puts "⚠️  No real data was fetched. This could mean:"
    puts "   - Your API subscriptions aren't active yet"
    puts "   - The search criteria don't match any properties"
    puts "   - You've hit API rate limits"
    puts ""
    puts "💡 Try running this script again in a few hours"
  else
    puts ""
    puts "🎉 Successfully fetched #{listings.length} real listings!"
    
    # Show database stats
    puts ""
    real_data_service.database_stats
    
    # Ask if they want to save to database
    puts ""
    print "Save this real data to database? (y/n): "
    save_response = gets.chomp.downcase
    
    if save_response == 'y'
      puts ""
      puts "Step 3: Saving to Database"
      puts "-" * 30
      real_data_service.save_real_data_to_database(listings)
      
      puts ""
      puts "🎉 Real data has been saved to your database!"
      puts "💡 You can now view it at: http://localhost:4000/listings"
    else
      puts "💾 Data was fetched but not saved to database"
    end
  end
  
rescue => e
  puts ""
  puts "❌ Error during data fetching: #{e.message}"
  puts "💡 This might be a temporary API issue. Try again later."
end

puts ""
puts "🏁 Test completed!"
puts "💡 Run 'ruby test_real_data.rb' again to test when your subscriptions are active" 