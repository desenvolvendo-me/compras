class CreditorDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def commercial_registration_date
    localize super if super
  end
  
  def cant_have_crc_message
    t('creditor.messages.cant_have_crc') unless company?
  end
end
