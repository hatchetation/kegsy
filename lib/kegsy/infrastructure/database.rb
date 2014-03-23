require 'kegsy/adapters/sequel/sequel_adapter'

module Kegsy
  module Infrastructure
    Kegsy::Adapters::Sequel::SequelAdapter.start
    DB = Kegsy::Adapters::Sequel::SequelAdapter.conn
  end
end
