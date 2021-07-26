class RegulatoryActDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :regulatory_act_type_humanize, :act_number, :creation_date, :link => [:regulatory_act_type_humanize, :act_number]

  def summary
    "Criado em #{localize creation_date}"
  end

  def regulatory_act_type_humanize
    component.regulatory_act_type_humanize if component.regulatory_act_type
  end
end
