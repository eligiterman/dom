class ApiConfig
  class << self
    def sources
      {
        'realty_in_us' => {
          'url' => 'https://realty-in-us.p.rapidapi.com/properties/v2/list-for-sale',
          'headers' => {
            'X-RapidAPI-Key' => ENV['RAPIDAPI_KEY'],
            'X-RapidAPI-Host' => 'realty-in-us.p.rapidapi.com'
          },
          'params' => {
            'city' => 'Los Angeles',
            'state_code' => 'CA',
            'limit' => 50,
            'offset' => 0,
            'sort' => 'relevant'
          }
        },
        'zillow_com1' => {
          'url' => 'https://zillow-com1.p.rapidapi.com/propertyExtendedSearch',
          'headers' => {
            'X-RapidAPI-Key' => ENV['RAPIDAPI_KEY'],
            'X-RapidAPI-Host' => 'zillow-com1.p.rapidapi.com'
          },
          'params' => {
            'location' => 'Los Angeles, CA',
            'home_type' => 'Houses',
            'limit' => 50
          }
        },
        'redfin_com_data' => {
          'url' => 'https://redfin-com-data.p.rapidapi.com/property/search',
          'headers' => {
            'X-RapidAPI-Key' => ENV['RAPIDAPI_KEY'],
            'X-RapidAPI-Host' => 'redfin-com-data.p.rapidapi.com'
          },
          'params' => {
            'city' => 'Los Angeles',
            'state' => 'CA',
            'limit' => 50
          }
        },

      }
    end

    def server_config
      {
        port: ENV['PORT'] || 4000,
        bind: '0.0.0.0',
        environment: ENV['ENVIRONMENT'] || 'development'
      }
    end

    def cache_config
      {
        duration: 300, # 5 minutes
        enabled: true
      }
    end

    def search_filters
      [
        'city',
        'state', 
        'min_price',
        'max_price',
        'min_bedrooms',
        'max_bedrooms',
        'min_bathrooms',
        'max_bathrooms',
        'property_type'
      ]
    end
  end
end 