class PurchasingUnitsController < CrudController
  has_scope :term
  has_scope :by_situation
  has_scope :by_purchase_solicitation
end