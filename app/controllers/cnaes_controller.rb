class CnaesController < CrudController
  skip_before_filter :authorize_resource!, only: [:modal]
  skip_before_filter :authenticate_user!, only: [:modal]
  actions :modal
  has_scope :term
  has_scope :cnaes_remainder, :type => :array
end
