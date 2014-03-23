# As indicated by the documentation for Jeremy Evan's Sequel gem,
# it appears as though we need to extend the Array and Hash class 
# in order to resolve the conflicts between active_support and 
# the standard JSON serialization provided by sequel.
class Array

  # Returns a JSON representation of itself.
  # 
  # @param options {Hash}.  A configuration hash that configures how to render the object to json.
  # @return {Hash}.  A JSON representation of the object.
  def to_json(options={})
    JSON.generate(self)
  end

end
