class LicitationProcessRatificationItemsController < CrudController
  actions :index

  has_scope :licitation_process_id, allow_blank: true
  has_scope :creditor_id, allow_blank: true
end
