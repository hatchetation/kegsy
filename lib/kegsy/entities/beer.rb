require 'json'
require 'sequel'

# name string
# on_tap bool
class Beer < Sequel::Model
  one_to_many :servings
  plugin :json_serializer

  def self.find_by_name(name)
    return DB["beers"].where({:name => name}).first
  end

  def self.find_or_create_by_name(name)
    beer = self.find_by_name(name)

    if beer.nil?
      beer = self.create({:name => name})
    end
    
    return beer
  end

  def self.on_tap
    return Beer.where({:on_tap => true})
  end

  # TODO pagination
  def self.to_index_beer_json
    config = {
      :include => {
        :kegs => {
          :include => {
            :lines => {
              :include => {
                :servings => {}
              }
            }
          }
        }
      }
    }
  end

end
