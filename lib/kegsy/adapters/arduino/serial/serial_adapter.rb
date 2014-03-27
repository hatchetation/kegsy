require "serialport"
require "agent"

module Kegsy
  module Adapters
    module Arduino
      module Serial
        
        class SerialAdapter

          cattr_accessor :serial_port, :message_chan

          def self.start
            # TODO Config file
            port_str = "/dev/ttyUSB0" 
            baud_rate = 9600
            data_bits = 8
            stop_bits = 1
            parity = SerialPort::NONE
            
            self.serial_port = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
            self.message_chan = channel! String
            
            go! self.recv
            go! self.work

          end

          def self.stop
            self.serial_port.close
          end

          def self.recv
            while true do
              while payload = self.serial_port.gets.chomp do
                self.message_chan << payload
              end
            end
          end

          def self.work
            select! do |s|
              s.case(self.message_chan, :receive) do |payload|
                # TODO process payload, save to logs
              end
            end
          end
        end
        
      end
    end
  end
end
