class CnaesController < CrudController
  has_scope :cnaes_remainder, :type => :array
end
