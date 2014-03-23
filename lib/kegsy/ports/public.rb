require 'sinatra'

module Kegsy
  module Ports
    class Public < Sinatra::Base

      get "/healthcheck" do
        [200, {}, {}]
      end

    end
  end
end
