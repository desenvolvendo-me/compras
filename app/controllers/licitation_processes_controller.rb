class LicitationProcessesController < CrudController
  actions :all, :except => [ :destroy ]

  has_scope :with_price_registrations, :type => :boolean
  has_scope :by_modality_type
  has_scope :without_trading
  has_scope :trading, :type => :boolean
  has_scope :published_edital, :type => :boolean

  def new
    object = build_resource
    object.year = Date.current.year
    object.process_date = Date.current
    object.status = LicitationProcessStatus::WAITING_FOR_OPEN

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to edit_licitation_process_path(resource) }
    end
  end

  def update
    if params[:commit] == 'Apurar'
      resource.transaction do
        LicitationProcessClassificationGenerator.new(resource).generate!

        LicitationProcessClassificationBiddersVerifier.new(resource).verify!

        LicitationProcessClassificationSituationGenerator.new(resource).generate!
      end

      redirect_to licitation_process_path(resource)
    else
      update! do |success, failure|
        success.html { redirect_to edit_licitation_process_path(resource) }
      end
    end
  end

  def show
    render :layout => 'report'
  end

  protected

  def default_filters
    { :year => lambda { Date.current.year } }
  end

  def interpolation_options
    { :resource_name => "#{resource_class.model_name.human} #{resource.process}/#{resource.year}" }
  end

  def create_resource(object)
    object.transaction do
      BidderStatusChanger.new(object).change

      object.licitation_number = object.next_licitation_number
      object.status = LicitationProcessStatus::WAITING_FOR_OPEN

      if super
        if params[:licitation_process]
          AdministrativeProcessBudgetAllocationCloner.clone(
            :licitation_process => object, :new_purchase_solicitation => new_purchase_solicitation)

          AdministrativeProcessItemGroupCloner.clone(object,
            :new_item_group => new_item_group)
        end

        PurchaseSolicitationBudgetAllocationItemFulfiller.new(
          :purchase_solicitation_item_group => object.purchase_solicitation_item_group,
          :licitation_process => object,
          :add_fulfill => true).fulfill

        PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
          :new_purchase_solicitation => new_purchase_solicitation,
          :licitation_process => object
        ).change

        PurchaseSolicitationItemGroupProcess.new(:new_item_group => new_item_group).update_status
        DeliveryLocationChanger.change(object.purchase_solicitation, object.delivery_location)
      end
    end
  end

  def update_resource(object, attributes)
    return unless object.updatable?

    old_item_group = object.purchase_solicitation_item_group
    old_purchase_solicitation = object.purchase_solicitation

    object.transaction do
      AdministrativeProcessBudgetAllocationCleaner.new(object, new_item_group).clear_old_records

      object.localized.assign_attributes(*attributes)

      BidderStatusChanger.new(object).change

      if object.save!
        DeliveryLocationChanger.change(object.purchase_solicitation, object.delivery_location)

        AdministrativeProcessBudgetAllocationCloner.clone(
          :licitation_process => object,
          :new_purchase_solicitation => new_purchase_solicitation,
          :old_purchase_solicitation => old_purchase_solicitation)

        AdministrativeProcessItemGroupCloner.clone(object,
          :new_item_group => new_item_group,
          :old_item_group => old_item_group)

        PurchaseSolicitationItemGroupProcess.new(
          :new_item_group => new_item_group,
          :old_item_group => old_item_group
        ).update_status

        PurchaseSolicitationBudgetAllocationItemFulfiller.new(
          :purchase_solicitation_item_group => old_item_group
        ).fulfill

        PurchaseSolicitationBudgetAllocationItemFulfiller.new(
          :purchase_solicitation_item_group => new_item_group,
          :licitation_process => object,
          :add_fulfill => true
        ).fulfill

        PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
          :new_purchase_solicitation => new_purchase_solicitation,
          :old_purchase_solicitation => old_purchase_solicitation,
          :new_purchase_solicitation_item_group => new_item_group,
          :old_purchase_solicitation_item_group => old_item_group,
          :licitation_process => object).change
      end
    end
  end

  def new_item_group
    item_group_id = params[:licitation_process][:purchase_solicitation_item_group_id]

    PurchaseSolicitationItemGroup.find(item_group_id) if item_group_id.present?
  end

  def new_purchase_solicitation
    purchase_solicitation_id = params[:licitation_process][:purchase_solicitation_id]

    PurchaseSolicitation.find(purchase_solicitation_id) if purchase_solicitation_id.present?
  end
end
