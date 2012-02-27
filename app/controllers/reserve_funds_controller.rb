class ReserveFundsController < CrudController
  def new
    object = build_resource
    object.status = ReserveFundStatus::RESERVED

    super
  end

  def create
    object = build_resource
    object.status = ReserveFundStatus::RESERVED

    super
  end

  def edit
    object = resource
    object.licitation = object.joined_licitation
    object.process = object.joined_process

    super
  end
end
