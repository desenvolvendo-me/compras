class LicitationProcessLotDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def winner_proposal_total_price
    number_to_currency super if super
  end

  def licitation_process_not_updatable_message
    t('licitation_process_lot.messages.licitation_process_not_updatable') unless licitation_process.updatable?
  end
end
