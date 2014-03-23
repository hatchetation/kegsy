module Kegsy
  module Services
    
    class IndexServingsService

      def self.handle(request, params)
        servings = Kegsy::Entities::Serving.all
        if !servings.empty?
          return [200, {"Content-type" => "application/json"}, servings.to_json]
        else
          return [404, {"Content-type" => "text/plain"}, "No Servings found."]
        end
      end

    end

  end
end
