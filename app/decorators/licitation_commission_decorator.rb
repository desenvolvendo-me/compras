class LicitationCommissionDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :description, :commission_type_humanize, :nomination_date

  def regulatory_act_publication_date
    localize super if super
  end
end
