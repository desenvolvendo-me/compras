class SupplyRequestAttendancesController < CrudController
  actions :all, :only => [:new, :create, :edit]

  before_filter :set_supply_request, :only => [:new, :create, :index]

  def new
    object = build_resource
    object.responsible = current_user.authenticable
    object.date = Date.current
    object.supply_request = @parent

    super
  end

  def create
    set_secretary
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

  def set_secretary
    secretary_id = params[:secretary_id]
    if secretary_id and @parent.present?
      @parent.signature_secretary_id = secretary_id
      @parent.signature_responsible_id = current_user.id
      @parent.secretary_signature = SecretarySetting.where(secretary_id: secretary_id, employee_id: current_user.id )&.last&.digital_signature
      @parent.save
    end
  end
end
