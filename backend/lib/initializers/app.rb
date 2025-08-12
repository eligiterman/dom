# Application initializer
# This file handles app startup and configuration

require 'dotenv/load'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/activerecord'

# Load all application files
Dir[File.join(__dir__, '..', 'models', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '..', 'services', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '..', 'controllers', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '..', 'config', '*.rb')].each { |file| require file }

# Configure Sinatra
configure do
  config = ApiConfig.server_config
  set :port, config[:port]
  set :bind, config[:bind]
  set :environment, config[:environment]
  
  # Enable logging
  enable :logging
  enable :dump_errors
  
  # Set JSON content type
  before do
    content_type 'application/json'
  end
end

# Configure database
set :database_file, 'config/database.yml'

# Error handling
error 404 do
  json error: 'Not Found', status: 404
end

error 500 do
  json error: 'Internal Server Error', status: 500
end 