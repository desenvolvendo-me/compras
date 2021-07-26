class StreetsController < CrudController
  skip_before_filter :authenticate_user!, :only => [:index, :show, :create]
  skip_before_filter :authorize_resource!, only: [:index, :show, :create]
  has_scope :neighborhood, allow_blank: true
  has_scope :term, allow_blank: true
  has_scope :by_zip_code, allow_blank: true
  has_scope :by_city, allow_blank: true
end
