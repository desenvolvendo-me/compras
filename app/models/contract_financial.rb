class ContractFinancial < Compras::Model
  attr_accessible :contract_id, :expense_id, :secretary_id, :value

  belongs_to :contract
  belongs_to :expense
  belongs_to :secretary

end
