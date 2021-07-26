class CreditorsController < CrudController
  has_scope :by_licitation_process, :allow_blank => true
  has_scope :term, :allow_blank => true
  has_scope :by_id, allow_blank: true
  has_scope :won_calculation, allow_blank: true
  has_scope :won_calculation_for_trading, allow_blank: true
  has_scope :without_direct_purchase_ratification, allow_blank: true
  has_scope :without_licitation_ratification, allow_blank: true
  has_scope :enabled_by_licitation, allow_blank: true
  has_scope :by_ratification_and_licitation_process_id, allow_blank: true
  has_scope :by_purchasing_unit, :allow_blank => true
  has_scope :by_contract, :allow_blank => true
  has_scope :by_bidders, :allow_blank => true

end
