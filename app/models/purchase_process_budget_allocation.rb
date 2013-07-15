class PurchaseProcessBudgetAllocation < Compras::Model
  include BelongsToResource

  attr_accessible :licitation_process_id, :budget_allocation_id, :value,
                  :expense_nature_id

  attr_modal :material, :quantity, :unit_price

  belongs_to :licitation_process
  belongs_to :budget_allocation

  belongs_to_resource :expense_nature

  delegate :expense_nature, :expense_nature_id, :amount,
           :to => :budget_allocation, :allow_nil => true, :prefix => true

  validates :budget_allocation, :value, :presence => true
end
