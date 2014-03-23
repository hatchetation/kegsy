module Kegsy
  module Services
    
    class IndexBeerService

      def self.handle(request)
        beers = Beer.all
        if !beers.empty?
          return [200, {"Content-type" => "application/json"}, beers.to_json]
        else
          return [400, {}, {}]
        end
      end

    end

  end
end
