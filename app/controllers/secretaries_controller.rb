class SecretariesController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :by_contract_expense, using: %i[expense contract]
end