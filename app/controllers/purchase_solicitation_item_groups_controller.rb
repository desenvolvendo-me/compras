class PurchaseSolicitationItemGroupsController < CrudController
  actions :all, :except => :destroy

  has_scope :not_annulled, :type => :boolean
  has_scope :pending, :type => :boolean

  def new
    object = build_resource
    object.status = PurchaseSolicitationItemGroupStatus::PENDING

    super
  end

  def create
    object = build_resource
    object.status = PurchaseSolicitationItemGroupStatus::PENDING

    super
  end

  protected

  def create_resource(object)
    object.transaction do
      return unless super

      PurchaseSolicitationBudgetAllocationItemStatusChanger.new({
        :new_item_ids => object.purchase_solicitation_item_ids
      }).change
    end
  end

  def update_resource(object, attributes)
    raise Exceptions::Unauthorized unless object.editable?

    object.transaction do
      old_purchase_solicitation_ids = object.purchase_solicitation_item_ids

      return unless super

      PurchaseSolicitationBudgetAllocationItemStatusChanger.new({
        :new_item_ids => object.purchase_solicitation_item_ids,
        :old_item_ids => old_purchase_solicitation_ids
      }).change
    end
  end
end
