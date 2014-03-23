$LOAD_PATH.unshift(File.dirname(__FILE__))

require "ext/array"
require "ext/hash"
require "ext/module"

require 'kegsy/adapters'
require 'kegsy/infrastructure'
require 'kegsy/entities'
require 'kegsy/ports'
require 'kegsy/events'

module Kegsy
end
