require 'sinatra'
require 'kegsy/services/index_beer_service'

module Kegsy
  module Ports
    module API
      
      class V1 < Sinatra::Base

        get "/beers" do
          Kegsy::Services::IndexBeerService.handle(request)
        end

        get "/beers/:id" do
          # TODO Implement
        end

        get "/kegs" do
          # TODO Implement
        end

        get "/kegs/:id" do
          # TODO Implement
        end
        
        get "/lines" do
          # TODO Implement
        end

        get "/lines/:id" do
          # TODO Implement
        end

        get "/servings" do
          # TODO Implement
        end
        
        get "/servings/:id" do
          # TODO Implement
        end

      end
      
    end
  end
end
