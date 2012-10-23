class AdministrativeProcessesController < CrudController
  actions :all, :except => :destroy

  has_scope :released, :type => :boolean

  def new
    object = build_resource
    object.date = Date.current
    object.year = Date.current.year
    object.status = AdministrativeProcessStatus::WAITING
    object.responsible = current_user.authenticable

    super
  end

  def update
    if resource.waiting?
      if params.has_key?(:commit) && params[:commit] == 'Anular'
        resource.status = AdministrativeProcessStatus::ANNULLED
        resource.save!
        redirect_to administrative_processes_path, :notice => t('compras.messages.administrative_process_annulled_successful')
      else
        super
      end
    else
      redirect_to edit_administrative_process_path(resource)
    end
  end

  def create
    object = build_resource
    object.status = AdministrativeProcessStatus::WAITING

    super
  end

  def show
    if resource.released?
      render :layout => 'report'
    else
      redirect_to edit_administrative_process_path(resource)
    end
  end

  protected

  def create_resource(object)
    object.transaction do
      super

      PurchaseSolicitationBudgetAllocationItemFulfiller.new(object.purchase_solicitation_item_group, object).fulfill
    end
  end

  def update_resource(object, attributes)
    old_item_group = object.purchase_solicitation_item_group

    object.transaction do
      AdministrativeProcessBudgetAllocationCleaner.new(object, new_item_group).clear_old_records

      if super
       PurchaseSolicitationBudgetAllocationItemFulfiller.new(old_item_group).fulfill
       PurchaseSolicitationBudgetAllocationItemFulfiller.new(new_item_group, object).fulfill
      end
    end
  end

  def new_item_group
    item_group_id = params[:administrative_process][:purchase_solicitation_item_group_id]

    PurchaseSolicitationItemGroup.find(item_group_id) if item_group_id.present?
  end
end
