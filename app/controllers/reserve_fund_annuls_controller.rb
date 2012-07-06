class ReserveFundAnnulsController < CrudController
  defaults :resource_class => ResourceAnnul

  actions :all, :except => [:update, :destroy]

  before_filter :block_reserve_fund_not_allowed, :only => [:new, :create]

  def new
    object = build_resource
    object.date = Date.current
    object.employee = current_user.authenticable
    object.annullable = @reserve_fund

    super
  end

  def create
    create!{ edit_reserve_fund_path(@reserve_fund) }
  end

  protected

  def create_resource(object)
    @reserve_fund.annul!

    super
  end

  def block_reserve_fund_not_allowed
    reserve_fund_id = params[:reserve_fund_id] || params[:resource_annul][:annullable_id]
    @reserve_fund = ReserveFund.find(reserve_fund_id)

    raise Exceptions::Unauthorized if @reserve_fund.annulled?
  end
end
