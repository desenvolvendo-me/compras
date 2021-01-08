module ReserveFundRequestsHelper
  def edit_title
    "Editar Reserva de Dotação"
  end

  def reserve_fund_action(resource)
    resource && resource.reserve_funds.empty? ? 'Criar' : 'Editar'
  end

  def budget_allocation_for_select(resource)
    resource.purchase_process_budget_allocations.map do |purchase_process_budget_allocation|
      [
        purchase_process_budget_allocation.budget_allocation,
        purchase_process_budget_allocation.budget_allocation_id,
        {
          'data-amount' => number_with_precision(purchase_process_budget_allocation.value),
          'data-descriptor_id' => purchase_process_budget_allocation.budget_allocation_descriptor_id
        }
      ]
    end
  end
end
