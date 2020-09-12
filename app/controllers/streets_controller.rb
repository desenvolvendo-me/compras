class StreetsController < CrudController
  skip_before_filter :authenticate_user!, :only => [:index]
  skip_before_filter :authorize_resource!, only: [:index]
  has_scope :neighborhood
  has_scope :term
end
