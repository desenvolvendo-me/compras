class RegulatoryActDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :regulatory_act_type, :act_number, :creation_date

  def summary
    "Criado em #{localize creation_date}"
  end
end
