#encoding: utf-8
module ReserveFundRequestsHelper
  def edit_title
    "Editar Reserva de Dotação"
  end

  def budget_allocation_for_select(resource)
    resource.purchase_process_budget_allocations.map do |purchase_process_budget_allocation|
      [
        purchase_process_budget_allocation.budget_allocation,
        purchase_process_budget_allocation.budget_allocation_id,
        { 'data-amount' => number_with_precision(purchase_process_budget_allocation.value) }
      ]
    end
  end
end
