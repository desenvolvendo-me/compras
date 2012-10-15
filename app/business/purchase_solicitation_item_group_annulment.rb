class PurchaseSolicitationItemGroupAnnulment
  attr_accessor :purchase_solicitation_item_group, :item_status_changer,
                :resource_annul_repository

  def initialize(purchase_solicitation_item_group,
                 item_status_changer = PurchaseSolicitationBudgetAllocationItemStatusChanger,
                 resource_annul_repository = ResourceAnnul)
    self.purchase_solicitation_item_group = purchase_solicitation_item_group
    self.item_status_changer = item_status_changer
    self.resource_annul_repository = resource_annul_repository
  end

  def create_annulment(employee, date, description = '')
    resource_annul_repository.create!(
      :employee_id => employee.id,
      :date => date,
      :description => description,
      :annullable_id => purchase_solicitation_item_group.id,
      :annullable_type => purchase_solicitation_item_group.class.name
    )

    item_status_changer.new({
      :old_item_ids => purchase_solicitation_item_group.purchase_solicitation_item_ids
    }).change

    purchase_solicitation_item_group.change_status!(PurchaseSolicitationItemGroupStatus::ANNULLED)
  end
end
