class SubpledgesController < CrudController
  def new
    object = build_resource
    object.date = resource_class.last.date if resource_class.any?

    super
  end

  def create
    object = build_resource
    GenerateNumberPledgeParcels.new(object.subpledge_expirations).generate!

    super
  end

  protected

  def create_resource(object)
    object.number = object.next_number

    super
  end
end
