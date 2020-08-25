class CnaesController < CrudController
  skip_before_filter :authorize_resource!, only: [:index]
  skip_before_filter :authenticate_user!, only: [:index]
  actions :modal
  has_scope :term
  has_scope :cnaes_remainder, :type => :array
end
