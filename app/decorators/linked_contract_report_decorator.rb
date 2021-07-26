class LinkedContractReportDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper


  def self.header_attributes
    [ 
      "#{LinkedContract.human_attribute_name :contract_number}",
      "#{Contract.human_attribute_name :creditor}",
      "#{Contract.human_attribute_name :content}".mb_chars.upcase.sub!(' DO CONTRATO/ATA',''),      
      "#{LinkedContract.human_attribute_name :contract_value}",
      "#{Contract.human_attribute_name :modality_humanize}",
      "#{LinkedContract.human_attribute_name :start_date_contract}",
      "#{LinkedContract.human_attribute_name :end_date_contract}",
      "#{Contract.human_attribute_name :status}"
    ]
  end
end