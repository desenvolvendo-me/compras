class AdministrativeProcessBudgetAllocationItemsController < CrudController
  has_scope :without_lot, :type => :boolean
  has_scope :administrative_process_id
  has_scope :without_lot_or_ids
end
