class CreditorDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :name, :identity_document, :company_size, :legal_nature, :choose_simple

  def commercial_registration_date
    localize super if super
  end

  def cant_have_crc_message
    t('creditor.messages.cant_have_crc') unless company?
  end
end
