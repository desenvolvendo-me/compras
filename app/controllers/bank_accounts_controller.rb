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
    object.transaction do
      super

      BankAccountCapabilitiesStatusChanger.new(object, Date.current).change!
    end
  end

  def update_resource(object, attributes)
    object.transaction do
      super

      BankAccountCapabilitiesStatusChanger.new(object, Date.current).change!
    end
  end
end
