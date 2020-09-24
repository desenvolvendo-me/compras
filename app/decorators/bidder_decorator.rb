class BidderDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :creditor, :enabled

  def by_licitation_process
    # na modalidade pregão só pode ser adicionado os credores credenciados
    licitation_process_id if licitation_process.modality_number == 6
  end

  def process_date
    localize component.licitation_process_process_date if component.licitation_process_process_date
  end

  def proposal_total_value_by_lot(lot_id = nil)
    number_with_precision super
  end

  def proposal_total_value
    number_to_currency(super, :format => "%n") if super
  end

  def cant_save_or_destroy_message
    if licitation_process_ratification?
      t('bidder.messages.cant_be_changed_when_licitation_process_has_a_ratification')
    end
  end

  def enabled
    t(super.to_s)
  end

  def benefited
    if component.benefited
      t('true')
    else
      t('false')
    end
  end
end
