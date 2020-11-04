class LinkedContractReportDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper


  def self.header_attributes
    [
      "#{LinkedContract.human_attribute_name :contract_number}",
      "#{LinkedContract.human_attribute_name :start_date_contract}",
      "#{LinkedContract.human_attribute_name :end_date_contract}",
      "#{Creditor.model_name.human}"
    ]
  end
end