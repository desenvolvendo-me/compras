class ContractsUnicoCreditor < Compras::Model
  attr_accessible :contract_id, :creditor_id

  set_primary_key :contract_id

  belongs_to :creditor
  belongs_to :contract

end
