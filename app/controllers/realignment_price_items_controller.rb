class RealignmentPriceItemsController < CrudController
  actions :index

  has_scope :purchase_process_id, allow_blank: true
  has_scope :creditor_id, allow_blank: true
end
