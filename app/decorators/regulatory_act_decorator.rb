class RegulatoryActDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def summary
    "Criado em #{localize creation_date}"
  end
end
