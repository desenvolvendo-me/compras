#encoding: utf-8
class PurchaseSolicitationBudgetAllocationItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def estimated_total_price
    number_with_precision super if super
  end

  def fulfiller
    "#{fulfiller_type_humanize} #{component.fulfiller}" if super.present?
  end

  def material_label
    services? ? "Serviço" : "Material"
  end

  def material_type_filter
    services? ? MaterialType::SERVICE : nil
  end
end
