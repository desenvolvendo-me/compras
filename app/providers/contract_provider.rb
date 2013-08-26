class ContractProvider < Provider
  provide :id, :to_s, :budget_allocations, :creditors, :contract_number,
          :licitation_process_id, :licitation_process_year, :signature_date,
          :year

  def budget_allocations
    component.licitation_process_budget_allocations_ids
  end

  def creditors
    component.creditors.order(:id).pluck(:id)
  end
end
