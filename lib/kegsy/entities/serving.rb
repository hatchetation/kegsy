class Serving < Sequel::Model
  plugin :json_serializer

  many_to_one :beer

end
