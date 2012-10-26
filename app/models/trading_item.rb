class TradingItem < Compras::Model
  attr_accessible :detailed_description, :minimum_reduction_percent,
                  :minimum_reduction_value, :order,
                  :administrative_process_budget_allocation_item_id

  belongs_to :trading
  belongs_to :administrative_process_budget_allocation_item

  delegate :material, :material_id, :reference_unit,
           :quantity, :unit_price,
           :to => :administrative_process_budget_allocation_item,
           :allow_nil => true
end
