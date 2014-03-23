module Kegsy
  module Services
    
    class GetBeerService

      def self.handle(request, params)

        # TODO human-readable slugs?
        beer = Kegsy::Entities::Beer.where({:id => params[:id]}).first
        if !beer.nil?
          return [200, {"Content-type"=>"application/json"}, beer.to_json]
        else
          return [404, {"Content-type" => "text/plain"}, "Beer #{params[:id]} Not Found."]
        end

      end
      
    end
    
  end
end
