class StreetsController < CrudController
  skip_before_filter :authorize_resource!, only: [:index, :show]
  has_scope :neighborhood
  has_scope :term
end
