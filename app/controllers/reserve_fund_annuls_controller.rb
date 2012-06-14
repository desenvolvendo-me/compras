class ReserveFundAnnulsController < CrudController
  actions :all, :except => [:update, :destroy]

  def new
    object = build_resource
    object.date = Date.current
    object.employee = current_user.authenticable
    object.reserve_fund_id = params[:reserve_fund_id]

    super
  end

  def create
    create!{ edit_reserve_fund_path(resource.reserve_fund) }
  end

  protected

  def create_resource(object)
    ReserveFundStatusChanger.new(object.reserve_fund).change!

    super
  end
end
