class PurchaseFormsController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :by_purchase_solicitation, :allow_blank => true


  def new
    object = build_resource

    super
  end
end
