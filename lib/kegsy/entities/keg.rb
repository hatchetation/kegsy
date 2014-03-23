module Kegsy
  module Entities
    class Keg < Sequel::Model
      plugin :json_serializer
      one_to_many :beer
      one_to_many :line
    end
  end
end
