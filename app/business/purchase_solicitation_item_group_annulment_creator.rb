class PurchaseSolicitationItemGroupAnnulmentCreator
  attr_accessor :purchase_solicitation_item_group, :resource_annul_repository,
                :item_group_annulment

  def initialize(purchase_solicitation_item_group, options = {})
    self.purchase_solicitation_item_group = purchase_solicitation_item_group
    self.resource_annul_repository = options.fetch(:resource_annul_repository) { ResourceAnnul }
    self.item_group_annulment = options.fetch(:item_group_annulment) { PurchaseSolicitationItemGroupAnnulment }
  end

  def create_annulment(employee, date, description = '')
    resource_annul_repository.create!(
      :employee_id => employee.id,
      :date => date,
      :description => description,
      :annullable_id => purchase_solicitation_item_group.id,
      :annullable_type => purchase_solicitation_item_group.class.name
    )

    item_group_annulment.new(purchase_solicitation_item_group).annul
  end
end
