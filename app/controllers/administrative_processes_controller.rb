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
        AdministrativeProcessAnnulment.new(resource, current_user).annul

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
      if super
        if params[:administrative_process]
          AdministrativeProcessBudgetAllocationCloner.clone(
            :administrative_process => object, :new_purchase_solicitation => new_purchase_solicitation)
          AdministrativeProcessItemGroupCloner.clone(object,
            :new_item_group => new_item_group)
        end

        PurchaseSolicitationBudgetAllocationItemFulfiller.new(
          :purchase_solicitation_item_group => object.purchase_solicitation_item_group,
          :administrative_process => object,
          :add_fulfill => true).fulfill

        PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
          :new_purchase_solicitation => new_purchase_solicitation,
          :administrative_process => object
        ).change

        PurchaseSolicitationItemGroupProcess.new(:new_item_group => new_item_group).update_status
        PurchaseSolicitationStatusChanger.change(new_purchase_solicitation)
      end
    end
  end

  def update_resource(object, attributes)
    old_item_group = object.purchase_solicitation_item_group
    old_purchase_solicitation = object.purchase_solicitation

    object.transaction do
      AdministrativeProcessBudgetAllocationCleaner.new(object, new_item_group).clear_old_records

      if super
        AdministrativeProcessBudgetAllocationCloner.clone(
          :administrative_process => object,
          :new_purchase_solicitation => new_purchase_solicitation,
          :old_purchase_solicitation => old_purchase_solicitation)
        AdministrativeProcessItemGroupCloner.clone(object,
          :new_item_group => new_item_group,
          :old_item_group => old_item_group)
        PurchaseSolicitationItemGroupProcess.new(
          :new_item_group => new_item_group, :old_item_group => old_item_group
        ).update_status
        PurchaseSolicitationBudgetAllocationItemFulfiller.new(
          :purchase_solicitation_item_group => old_item_group
        ).fulfill
        PurchaseSolicitationBudgetAllocationItemFulfiller.new(
          :purchase_solicitation_item_group => new_item_group,
          :administrative_process => object,
          :add_fulfill => true
        ).fulfill

        PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
          :new_purchase_solicitation => new_purchase_solicitation,
          :old_purchase_solicitation => old_purchase_solicitation,
          :new_purchase_solicitation_item_group => new_item_group,
          :old_purchase_solicitation_item_group => old_item_group,
          :administrative_process => object).change

        PurchaseSolicitationStatusChanger.change(new_purchase_solicitation)
        PurchaseSolicitationStatusChanger.change(old_purchase_solicitation)
      end
    end
  end

  def new_item_group
    item_group_id = params[:administrative_process][:purchase_solicitation_item_group_id]

    PurchaseSolicitationItemGroup.find(item_group_id) if item_group_id.present?
  end

  def new_purchase_solicitation
    purchase_solicitation_id = params[:administrative_process][:purchase_solicitation_id]

    PurchaseSolicitation.find(purchase_solicitation_id) if purchase_solicitation_id.present?
  end
end
