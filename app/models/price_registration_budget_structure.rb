class PriceRegistrationBudgetStructure < Compras::Model
  attr_accessible :quantity_requested, :ride, :budget_structure_id,
                  :price_registration_item_id

  belongs_to :price_registration_item
  belongs_to :budget_structure

  validates :price_registration_item, :budget_structure, :quantity_requested,
            :presence => true
  validates :budget_structure_id, :uniqueness => { :scope => :price_registration_item_id }

  filterize
  orderize :id

  def budget_structure_balance; end
end
