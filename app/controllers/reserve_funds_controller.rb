class ReserveFundsController < CrudController
  actions :all, :except => [:update, :destroy]

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
end
