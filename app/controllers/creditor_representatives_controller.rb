class CreditorRepresentativesController < CrudController
  actions :index

  has_scope :term, :allow_blank => true
end
