class AdministrativeProcessBudgetAllocationItemsController < CrudController
  has_scope :without_licitation_process_lot, :type => :boolean
  has_scope :administrative_process_id
end
