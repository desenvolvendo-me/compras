class ExtractConsumptionPerProcessReport < Report

  attr_accessor :licitation_process, :licitation_process_id, :creditor, :creditor_id, :contract, :contract_id,
                :purchase_solicitation, :purchase_solicitation_id

  validates :licitation_process, presence: true
end