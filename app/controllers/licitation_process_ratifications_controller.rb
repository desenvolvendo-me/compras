class LicitationProcessRatificationsController < CrudController
  actions :all, :except => :destroy

  def new
    object = build_resource
    object.ratification_date = Date.current
    object.adjudication_date = Date.current

    super
  end

  def show
    render :layout => 'report'
  end
end
