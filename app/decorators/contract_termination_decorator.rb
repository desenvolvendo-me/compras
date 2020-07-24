class ContractTerminationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :number, :year, :status, :expiry_date, :termination_date

  def is_annulled_message
    t('contract_termination.messages.is_annulled') if annulled?
  end
end
