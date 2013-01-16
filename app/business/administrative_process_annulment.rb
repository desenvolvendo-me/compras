class AdministrativeProcessAnnulment
  attr_accessor :administrative_process, :item_group_annulment_creator,
                :budget_allocation_fulfiller, :current_user

  delegate :purchase_solicitation_item_group, :to => :administrative_process

  def initialize(administrative_process, current_user, options = {})
    self.administrative_process = administrative_process
    self.current_user = current_user
    self.item_group_annulment_creator = options.fetch(:item_group_annulment_creator) { PurchaseSolicitationItemGroupAnnulmentCreator }
    self.budget_allocation_fulfiller = options.fetch(:budget_allocation_fulfiller) { PurchaseSolicitationBudgetAllocationItemFulfiller }
  end

  def annul
    administrative_process.update_status(AdministrativeProcessStatus::ANNULLED)

    clear_budget_allocation_item_fulfiller

    annul_item_group
  end

  private

  def clear_budget_allocation_item_fulfiller
    return unless purchase_solicitation_item_group.present?

    budget_allocation_fulfiller.new(:purchase_solicitation_item_group => purchase_solicitation_item_group).fulfill
  end

  def annul_item_group
    return unless purchase_solicitation_item_group.present?

    item_group_annul = item_group_annulment_creator.new(purchase_solicitation_item_group)

    item_group_annul.create_annulment(
      current_user.authenticable,
      Date.current,
      annulment_message
    )
  end

  def annulment_message
    I18n.t 'other.compras.messages.annulled_through_administrative_process', :administrative_process => administrative_process
  end
end
