class PurchaseSolicitationBudgetAllocation < Compras::Model
  attr_accessible :purchase_solicitation_id, :budget_allocation_id, :blocked
  attr_accessible :expense_nature_id

  belongs_to :purchase_solicitation
  belongs_to :budget_allocation
  belongs_to :expense_nature

  delegate :annulled?, :services?, :to => :purchase_solicitation, :allow_nil => true
  delegate :to_s, :to => :budget_allocation, :allow_nil => true

  validates :budget_allocation, :presence => true
end
