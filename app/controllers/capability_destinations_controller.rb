class CapabilityDestinationsController < CrudController
  def create_resource(object)
    object.capability_destination_details.each { |c| c.active! }

    super
  end
end
