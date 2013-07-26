#encoding: utf-8
module ReserveFundRequestsHelper
  def edit_title
    "Editar Reserva de Dotação"
  end

  def budget_allocation_for_select(resource)
    resource.budget_allocations.map do |budget_allocation|
      [budget_allocation, budget_allocation.id]
    end
  end
end
