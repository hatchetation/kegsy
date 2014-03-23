require 'sequel'

module Kegsy
  module Entities

    class Serving < Sequel::Model
      plugin :json_serializer

      many_to_one :beer
      many_to_one :keg
      many_to_one :line

    end
  end
end
