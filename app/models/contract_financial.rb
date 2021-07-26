class ContractFinancial < Compras::Model
  attr_accessible :contract_id, :expense_id, :secretary_id, :value

  belongs_to :contract
  belongs_to :expense
  belongs_to :secretary

  has_one :project_activity, through: :expense

  delegate :nature_expense, :resource_source, to: :expense, allow_nil: true
  delegate :name, to: :project_activity, allow_nil: true, prefix: true
end
