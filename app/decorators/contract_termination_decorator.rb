class ContractTerminationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :status

  def is_annulled_message
    t('contract_termination.messages.is_annulled') if annulled?
  end
end
