class BidOpeningsController < CrudController
  actions :all, :except => [:update, :destroy]

  def new
    object = build_resource
    object.date = Date.current
    object.year = Date.current.year
    object.bid_opening_status = BidOpeningStatus::WAITING
    object.responsible = current_user.employee

    super
  end

  def create
    object = build_resource
    object.bid_opening_status = BidOpeningStatus::WAITING

    super
  end
end
