class SecretariesController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :by_contract_expense, using: %i[expense contract]
  has_scope :by_department
  has_scope :by_contract
end