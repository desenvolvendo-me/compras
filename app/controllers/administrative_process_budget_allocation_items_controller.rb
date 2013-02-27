class AdministrativeProcessBudgetAllocationItemsController < CrudController
  has_scope :without_lot, :type => :boolean
  has_scope :licitation_process_id
  has_scope :without_lot_or_ids
end
