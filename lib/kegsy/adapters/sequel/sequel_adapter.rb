require 'sequel'
require 'ext/module'
require 'kegsy/infrastructure/app_config'

module Kegsy
  module Adapters
    module Sequel

      class SequelAdapter

        cattr_accessor :conn

        def self.start
          openstr = Kegsy::Infrastructure::AppConfig.mysql_openstr
          self.conn = ::Sequel.connect(openstr)
        end

      end

    end
  end
end
    
