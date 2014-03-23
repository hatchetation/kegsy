$LOAD_PATH.unshift(File.dirname(__FILE__))

require "ext/array"
require "ext/hash"
require "ext/module"

require 'kegsy/adapters'
require 'kegsy/infrastructure'
Kegsy::Adapters::Sequel::SequelAdapter.start

require 'kegsy/entities'
require 'kegsy/ports'
require 'kegsy/events'

module Kegsy
end
