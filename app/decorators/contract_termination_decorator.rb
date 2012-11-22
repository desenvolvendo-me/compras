class ContractTerminationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def is_annulled_message
    t('contract_termination.messages.is_annulled') if annulled?
  end
end