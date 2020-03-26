class SupplyOrdersController < CrudController
  has_scope :by_purchasing_unit
end