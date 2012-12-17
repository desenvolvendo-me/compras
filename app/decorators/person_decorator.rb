class PersonDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :name, :id, :identity_document, :to_s => false, :link => :name

  def commercial_registration_date
    localize super if super
  end
end
