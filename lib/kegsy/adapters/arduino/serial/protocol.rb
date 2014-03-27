module Kegsy
  module Adapters
    module Arduino
      module Serial 

        class Protocol
          
          Message = Struct.new(:event_id, :tap_id, :pour_sequence_id, :duration, :details, :received_at)
          
          # @return {Kegsy::Adapters::Arduino::Serial::Protocol::Message}.
          def self.message_from_payload(payload)
            
            
            Message.new(event_id, tap_id, pour_sequence_id, duration, details, Time.now)
          end
          
          # TODO 
          #   - Define protocol
          #   - Parse incoming byte streams
          #   - Determine Persistence (logs?  db?)
          #   - Create and Persist events from messages
        end

      end
    end
  end
end
