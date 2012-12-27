module ContractsHelper
  def contract_termination_path
    if resource.allow_termination?
      new_contract_termination_path(:contract_id => resource.id)
    else
      edit_contract_termination_path(resource.contract_termination, :contract_id => resource.id)
    end
  end
end
