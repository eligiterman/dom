class ApiConfig
  class << self
    def sources
      {
        'realty_mole' => {
          'url' => 'https://realty-mole-property-api.p.rapidapi.com/properties',
          'headers' => {
            'X-RapidAPI-Key' => ENV['RAPIDAPI_KEY'],
            'X-RapidAPI-Host' => 'realty-mole-property-api.p.rapidapi.com'
          },
          'params' => {
            'city' => 'Los Angeles',
            'state' => 'CA',
            'limit' => 50
          }
        },
        'rentspree' => {
          'url' => 'https://rentspree.p.rapidapi.com/properties',
          'headers' => {
            'X-RapidAPI-Key' => ENV['RAPIDAPI_KEY'],
            'X-RapidAPI-Host' => 'rentspree.p.rapidapi.com'
          },
          'params' => {
            'city' => 'Los Angeles',
            'state' => 'CA',
            'limit' => 50
          }
        },
        'zillow' => {
          'url' => 'https://zillow56.p.rapidapi.com/search',
          'headers' => {
            'X-RapidAPI-Key' => ENV['RAPIDAPI_KEY'],
            'X-RapidAPI-Host' => 'zillow56.p.rapidapi.com'
          },
          'params' => {
            'location' => 'Los Angeles, CA',
            'limit' => 50
          }
        }
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