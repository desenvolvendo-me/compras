class ContractDepartment < Compras::Model
  attr_accessible :contract_id, :department_id

  belongs_to :contract
  belongs_to :department

end
