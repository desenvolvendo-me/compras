class PurchaseFormItem < Compras::Model
  belongs_to :purchase_solicitation
  belongs_to :purchase_form
  # attr_accessible :title, :body

  # scope :by_purchase_form, lambda { |purchase_form_ids|
  #   purchase_form_ids = [purchase_form_ids]
  #   where { |purchase_form| purchase_form.purchase_form_id.in purchase_form_ids }
  # }
  # try

end
