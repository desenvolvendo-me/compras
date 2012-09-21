class AgreementBankAccountDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def creation_date(date_repository = ::Date)
    if component.creation_date?
      date_current_or_creation_date = component.creation_date
    else
      date_current_or_creation_date = date_repository.current
    end

    localize date_current_or_creation_date
  end
end
