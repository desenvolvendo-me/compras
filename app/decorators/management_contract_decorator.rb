class ManagementContractDecorator < Decorator
  attr_modal :year, :contract_number, :process_number, :signature_date

  attr_data 'signature-date' => :signature_date
end
