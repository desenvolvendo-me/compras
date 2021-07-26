class ContractAdditiveReportDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper


  def self.header_attributes
    [
      "#{ContractAdditive.human_attribute_name :number}",
      "#{Contract.human_attribute_name :creditor}",
      "#{Contract.human_attribute_name :content}".mb_chars.upcase.sub!(' DO CONTRATO/ATA',''),
      "#{Contract.human_attribute_name :contract_value}",
      "#{Contract.human_attribute_name :modality_humanize}",
      "#{ContractAdditive.human_attribute_name :start_validity}",
      "#{ContractAdditive.human_attribute_name :end_validity}",
      "#{Contract.human_attribute_name :status}"
    ]
  end
end