class AgreementBankAccountDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def creation_date(date_repository = ::Date)
    localize component.creation_date || date_repository.current
  end
end
