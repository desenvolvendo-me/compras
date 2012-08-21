class RecordPriceBudgetStructure < Compras::Model
  attr_accessible :quantity_requested, :ride, :budget_structure_id,
                  :record_price_item_id

  belongs_to :record_price_item
  belongs_to :budget_structure

  validates :record_price_item, :budget_structure, :quantity_requested,
            :presence => true

  filterize
  orderize :id

  def budget_structure_balance; end
end
