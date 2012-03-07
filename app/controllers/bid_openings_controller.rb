class BidOpeningsController < CrudController
  def new
    object = build_resource
    object.date = Date.current
    object.year = Date.current.year
    object.bid_opening_status = BidOpeningStatus::WAITING
    object.responsible = current_user.employee

    super
  end
end
