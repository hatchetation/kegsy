module Kegsy
  module Services
    
    class IndexBeerService

      def self.handle(request, params)
        beers = Kegsy::Entities::Beer.all
        if !beers.empty?
          return [200, {"Content-type" => "application/json"}, beers.to_json]
        else
          return [404, {"Content-type" => "text/plain"}, "No Beers found."]
        end
      end

    end

  end
end
