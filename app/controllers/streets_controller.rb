class StreetsController < CrudController
  has_scope :neighborhood
  has_scope :term
end
