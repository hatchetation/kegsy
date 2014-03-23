require 'yaml'

module Kegsy
  module Infrastructure

    class AppConfig

      @@config = nil
      
      def self.mysql_openstr
        self.ensure_config
        
        mysql = @@config["mysql"]
        host = mysql["host"]
        port = mysql["port"]
        user = mysql["username"]
        password = mysql["password"]
        database = mysql["database"]
        driver = mysql["driver"]
        
        return "#{driver}://#{user}:#{password}@#{host}:#{port}/#{database}"
      end

      def self.ensure_config
        if @@config.nil?
          @@config = self.from_file
        end
      end

      def self.from_file(file="../../../config/default/kegsy.yml")
        path = File.expand_path("../#{file}", __FILE__)
        body = File.open(path).read
        return YAML.load(body)
      end

    end

  end
end
