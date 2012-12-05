class RegulatoryActDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :regulatory_act_type, :act_number, :creation_date, :to_s => false, :link => :regulatory_act_type

  def summary
    "Criado em #{localize creation_date}"
  end
end
