require 'rack'
require 'sinatra'

require File.expand_path("../lib/kegsy.rb", __FILE__)

map "/" do
  run Kegsy::Ports::Public
end

map "/1" do
  run Kegsy::Ports::API::V1
end
