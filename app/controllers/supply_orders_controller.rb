class SupplyOrdersController < CrudController
  has_scope :by_purchasing_unit

  def new
    super
  end
end