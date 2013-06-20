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
    I18n.t("#{allowed?}")
  end

  def not_selected_class
    return if allowed?
    'not_selected'
  end

  def personable_type
    creditor_personable_type_humanize
  end

  def has_power_of_attorney_text
    I18n.t("#{has_power_of_attorney?}")
  end

  def kind_text
    kind_humanize
  end

  private

  def allowed?
    has_power_of_attorney? || creditor_individual?
  end
end
