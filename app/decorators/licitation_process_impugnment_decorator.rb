class LicitationProcessImpugnmentDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def licitation_process_envelope_delivery_date
    localize super if super
  end

  def licitation_process_envelope_opening_date
    localize super if super
  end

  def licitation_process_envelope_delivery_time
    localize(super, :format => :hour) if super
  end

  def licitation_process_envelope_opening_time
    localize(super, :format => :hour) if super
  end

  def is_not_pending_message
    t('licitation_process_impugnment.messages.is_not_pending') unless pending?
  end
end
