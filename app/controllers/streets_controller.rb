class StreetsController < CrudController
  skip_before_filter :authenticate_user!, :only => [:index, :show]
  skip_before_filter :authorize_resource!, only: [:index, :show]
  has_scope :neighborhood
  has_scope :term
  has_scope :by_zip_code
end
