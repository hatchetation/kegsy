require 'sinatra'
require 'kegsy/services/index_beer_service'
require 'kegsy/services/get_beer_service'
require 'kegsy/services/index_keg_service'
require 'kegsy/services/index_servings_service'

module Kegsy
  module Ports
    module API
      
      class V1 < Sinatra::Base

        get "/beers" do
          Kegsy::Services::IndexBeerService.handle(request, params)
        end

        get "/beers/:id" do
          Kegsy::Services::GetBeerService.handle(request, params)
        end

        get "/kegs" do
          Kegsy::Services::IndexKegService.handle(request, params)
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
          Kegsy::Services::IndexServingsService.handle(request, params)
        end
        
        get "/servings/:id" do
          # TODO Implement
        end

      end
      
    end
  end
end
