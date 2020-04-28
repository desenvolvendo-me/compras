class SupplyRequestAttendancesController < CrudController
  actions :all, :only => [:new, :create, :edit]

  before_filter :set_supply_request, :only => [:new, :create]

  def new
    object = build_resource
    object.responsible = current_user.authenticable
    object.date = Date.current
    object.supply_request = @parent

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to(edit_supply_request_path(@parent.id)) }
    end
  end

  def begin_of_association_chain
    if params[:supply_request_id]
      @parent = SupplyRequest.find(params[:supply_request_id])
    end
  end

  private

  def set_supply_request
    @parent ||= SupplyRequest.find(params[:supply_request_id] ||
                                       params[:supply_request_attendance][:supply_request_id])
  end
end
