class ContractProvider < Provider
  provide :id, :to_s, :creditors, :contract_number, :signature_date

  def creditors
    component.creditors.order(:id).pluck(:id)
  end
end
