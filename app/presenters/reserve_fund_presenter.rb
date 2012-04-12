class ReserveFundPresenter < Presenter::Proxy
  attr_modal :licitation_modality_id, :creditor_id, :status
  attr_modal :entity_id, :year, :budget_allocation_id, :reserve_allocation_type_id
end
