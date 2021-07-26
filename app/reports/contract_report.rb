class ContractReport < Report

  attr_accessor :contract_number,
                :year,:creditor,:creditor_id,:publication_date,
                :content,:contract_value,:modality_humanize,
                :start_date,:end_date,:content,:status

  has_enumeration_for :status, with: ContractStatus, create_helpers: true

end
