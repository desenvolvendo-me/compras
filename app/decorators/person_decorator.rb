class PersonDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def commercial_registration_date
    localize super if super
  end
end
