class PurchaseProcessItemsController < CrudController
  has_scope :without_lot, :type => :boolean
  has_scope :licitation_process_id, allow_blank: true
  has_scope :without_lot_or_ids, allow_blank: true
  has_scope :creditor_id, allow_blank: true
  has_scope :ratification_creditor_id, allow_blank: true
end
