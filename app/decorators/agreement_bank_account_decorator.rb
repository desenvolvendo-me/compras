class AgreementBankAccountDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def creation_date(date_repository = ::Date)
    #if component.creation_date?
      #current_date_or_creation_date = component.creation_date
    #else
      #current_date_or_creation_date = date_repository.current
    #end

    #localize current_date_or_creation_date
    localize component.creation_date || date_repository.current
  end
end
