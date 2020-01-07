module Report::BalancePerCreditorHelper

  def self.get_contracts(creditor, licitation_process, department)
    contracts = creditor.contracts.joins(licitation_process: [purchase_solicitations: [purchase_solicitation: :department]])
    contracts = contracts.where(id: licitation_process) if licitation_process.present?
    contracts = contracts.where("compras_departments.id = #{department}") if department.present?
    contracts
  end

end