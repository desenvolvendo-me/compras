class ContractsController < CrudController
  has_scope :founded, :type => :boolean
  has_scope :management, :type => :boolean
end
