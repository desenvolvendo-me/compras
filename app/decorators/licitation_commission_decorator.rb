class LicitationCommissionDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def regulatory_act_publication_date
    localize super if super
  end
end
