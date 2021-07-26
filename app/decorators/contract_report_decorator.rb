class ContractReportDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper


  def self.header_attributes
    [
      (Contract.human_attribute_name :contract_number).mb_chars.upcase,
      (Contract.human_attribute_name :creditor).mb_chars.upcase,
      (Contract.human_attribute_name :content).mb_chars.upcase.sub!(' DO CONTRATO/ATA',''), 
      (Contract.human_attribute_name :contract_value).mb_chars.upcase, 
      (Contract.human_attribute_name :modality_humanize).mb_chars.upcase,
      (Contract.human_attribute_name :start_date).mb_chars.upcase,
      (Contract.human_attribute_name :end_date).mb_chars.upcase,
      (Contract.human_attribute_name :status).mb_chars.upcase
    ]
  end
end