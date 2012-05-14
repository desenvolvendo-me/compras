class PrecatoryTypesController < CrudController
  has_scope :active, :type => :boolean
end
