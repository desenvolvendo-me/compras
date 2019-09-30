class PurchaseFormItem < Compras::Model
  attr_accessible :purchase_form_id

  belongs_to :purchase_solicitation
  belongs_to :purchase_form

end
