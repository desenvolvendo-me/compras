class ContractAdditiveReportDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper


  def self.header_attributes
    [
      "#{ContractAdditive.human_attribute_name :number}",
      "#{ContractAdditive.human_attribute_name :additive_kind}",
      "#{ContractAdditive.human_attribute_name :additive_type}",
      "#{ContractAdditive.human_attribute_name :start_validity}",
      "#{ContractAdditive.human_attribute_name :end_validity}"
    ]
  end
end