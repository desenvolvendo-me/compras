class CreditorsController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :by_id, allow_blank: true
  has_scope :won_calculation, allow_blank: true
  has_scope :without_direct_purchase_ratification, allow_blank: true
  has_scope :without_licitation_ratification, allow_blank: true
  has_scope :enabled_by_licitation, allow_blank: true
  has_scope :by_ratification_and_licitation_process_id, allow_blank: true
end
