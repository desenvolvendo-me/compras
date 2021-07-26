class PurchaseProcessAccreditationCreditorDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def creditor_representative
    creditor.try(:creditor_representative) || 'Não possui representante'
  end

  def unit_price_of_proposal(purchase_process_id, item_or_lot)
    return '-' unless proposal(purchase_process_id, item_or_lot)

    number_with_precision proposal(purchase_process_id, item_or_lot).unit_price
  end

  def selected?(purchase_process_id, item_or_lot)
    I18n.t("#{allowed?(purchase_process_id, item_or_lot)}")
  end

  def not_selected_class(purchase_process_id, item_or_lot)
    return if allowed?(purchase_process_id, item_or_lot)
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

  def allowed?(purchase_process_id, item_or_lot)
    (has_power_of_attorney? || creditor_individual?) && proposal_qualified?(purchase_process_id, item_or_lot)
  end

  def proposal_qualified?(purchase_process_id, item_or_lot)
    return false unless proposal(purchase_process_id, item_or_lot)

    proposal(purchase_process_id, item_or_lot).qualified?
  end

  def proposal(purchase_process_id, item_or_lot)
    if judgment_form_item?
      creditor_proposal_by_item(purchase_process_id, item_or_lot)
    else
      creditor_proposal_by_lot(purchase_process_id, item_or_lot)
    end
  end
end
