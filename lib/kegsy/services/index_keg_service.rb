module Kegsy
  module Services
    
    class IndexKegService

      def self.handle(request, params)
        kegs = Keg.all
        if !kegs.empty?
          return [200, {"Content-type" => "application/json"}, kegs.to_json]
        else
          return [404, {"Content-type" => "text/plain"}, "No Kegs found."]
        end
      end

    end

  end
end
