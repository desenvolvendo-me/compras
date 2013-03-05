class CnaesController < CrudController
  actions :modal

  has_scope :cnaes_remainder, :type => :array
end
