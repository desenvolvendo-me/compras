class PurchaseSolicitationBudgetAllocation < Compras::Model
  include BelongsToResource

  attr_accessible :purchase_solicitation_id, :budget_allocation_id, :blocked,
                  :expense_nature_id, :estimated_value

  belongs_to :purchase_solicitation
  belongs_to :budget_allocation

  belongs_to_resource :expense_nature

  delegate :annulled?, :services?, :to => :purchase_solicitation, :allow_nil => true
  delegate :to_s, :to => :budget_allocation, :allow_nil => true
  delegate :expense_nature, :amount, :to => :budget_allocation, :allow_nil => true,
           :prefix => true

  validates :budget_allocation, :presence => true
end
