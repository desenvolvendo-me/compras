class ContractTypesController < CrudController
  has_scope :term, allow_blank: true
end
