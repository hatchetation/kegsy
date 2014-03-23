require 'json'
require 'sequel'

# name string
# on_tap bool
module Kegsy
  module Entities
    
    class Beer < Sequel::Model
      plugin :json_serializer

      one_to_many :keg
      one_to_many :servings
      
      
      def self.find_by_name(name)
        return self.where({:name => name}).first
      end
      
      def self.find_or_create_by_name(name)
        beer = self.find_by_name(name)
        
        if beer.nil?
          beer = self.create({:name => name})
        end
        
        return beer
      end
      
      def self.on_tap
        return self.where({:on_tap => true})
      end
      
      # TODO pagination
      def self.to_index_beers_json
        config = {
          :include => [
            :servings
          ]
        }

        self.to_json(config)
      end
      
    end
    
  end
end
