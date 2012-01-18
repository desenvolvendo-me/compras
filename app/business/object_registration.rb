class ObjectRegistration
  # Class responsible to receive an array of object
  # that respond_to #value and format with a period
  #
  attr_accessor :object

  def initialize(object)
    self.object = object
  end

  def format
    object.map(&:value).join('.')
  end
end
