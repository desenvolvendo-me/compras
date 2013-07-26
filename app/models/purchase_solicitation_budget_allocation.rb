class PurchaseSolicitationBudgetAllocation < Compras::Model
  include BelongsToResource

  attr_accessible :purchase_solicitation_id, :budget_allocation_id, :blocked,
                  :expense_nature_id, :estimated_value

  belongs_to :purchase_solicitation

  belongs_to_resource :expense_nature
  belongs_to_resource :budget_allocation

  delegate :annulled?, :services?, :to => :purchase_solicitation, :allow_nil => true
  delegate :to_s, :to => :budget_allocation, :allow_nil => true
  delegate :expense_nature, :balance, :to => :budget_allocation, :allow_nil => true,
           :prefix => true

  validates :budget_allocation_id, :presence => true

  private

  def budget_allocation_params
    { includes: :expense_nature, methods: :balance }
  end
end
