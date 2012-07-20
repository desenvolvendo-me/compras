class RevenueNatureDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def publication_date
    localize super if super
  end
end
