class BankAccountsController < CrudController
  def new
    object = build_resource
    object.status = Status::ACTIVE

    super
  end

  def create
    object = build_resource
    object.status = Status::ACTIVE

    super
  end

  def create_resource(object)
    super

    object.transaction do
      BankAccountCapabilitiesStatusVerifier.new(object.capabilities, Date.current).verify!
    end
  end

  def update_resource(object, attributes)
    super

    object.transaction do
      BankAccountCapabilitiesStatusVerifier.new(object.capabilities, Date.current).verify!
    end
  end
end
