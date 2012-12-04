class CreditorDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :name, :creditable_type, :to_s => false, :link => :name

  def commercial_registration_date
    localize super if super
  end

  def cant_have_crc_message
    t('creditor.messages.cant_have_crc') unless company?
  end
end
