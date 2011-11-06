require 'httparty'

module Zomato

  class Api
    include HTTParty
    format :json
    base_uri 'http://api.zomato.com/v1/'
    default_params :format => 'json', :apikey => ZOMATO_API_KEY
    
    def self.get_recommended_events_by_city(city_id)
      get('/events/recommended', :query => {:city_id => city_id}).parsed_response['recommendedevents']
    end
    
    def self.get_recommended_restaurants(lat, lon)
      get('/search', :query => {:lat => lat, :lon => lon, :radius => 1000}).parsed_response['results']
    end
    
    def self.get_event_details(id)
      get("/event/#{id}").parsed_response['event']
    end
    
    def self.get_restaurant_details(id)
      begin
        get("/restaurant/#{id}").parsed_response
      rescue
        # one of the restaurants (912) was flawed
        get("/restaurant/315").parsed_response
      end
    end
  end
  
end