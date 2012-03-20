class LicitationObjectValue
  attr_accessor :object, :modality, :limit

  def initialize(object, args)
    self.object = object
    self.modality = args[:modality]
    self.limit = args[:limit]
  end

  def value
    object.send("#{modality}_#{limit}".to_sym)
  end
end
