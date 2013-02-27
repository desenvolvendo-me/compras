class DeliveryLocationChanger
  # object can be both licitation_process or purchase solicitation
  def initialize(object, delivery_location)
    @object = object
    @delivery_location = delivery_location
  end

  def self.change(*param)
    new(*param).change!
  end

  def change!
    return unless delivery_location

    change_object
  end

  private

  attr_reader :object, :delivery_location

  def change_object
    return unless object_delivery_location? && delivery_location_changed?

    object.update_attributes(:delivery_location_id => delivery_location.id)
  end

  def delivery_location_changed?
    object.delivery_location != delivery_location
  end

  def object_delivery_location?
    object.respond_to?(:delivery_location)
  end
end
