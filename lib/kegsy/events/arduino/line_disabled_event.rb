module Kegsy
  module Events
    module Arduino
      
      class LineDisabledEvent

        def initialize(options={})
          # TODO Persist event so that we can backfill our db
          # TODO Disable the line identified in the protocol
        end

      end

    end
  end
end
