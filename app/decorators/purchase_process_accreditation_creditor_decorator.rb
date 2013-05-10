# encoding: utf-8
class PurchaseProcessAccreditationCreditorDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def creditor_representative
    super || 'Não possui representante'
  end

  def unit_price_of_proposal_by_item(item)
    return '-' unless creditor_proposal_by_item(item)

    number_with_precision(creditor_proposal_by_item(item).unit_price)
  end

  def selected?
    I18n.t("#{has_power_of_attorney}")
  end
end
