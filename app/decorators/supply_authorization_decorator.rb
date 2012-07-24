# encoding: utf-8
class SupplyAuthorizationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Routes
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TranslationHelper

  def date
    localize super
  end

  def direct_purchase
    "#{component.direct_purchase.id}/#{component.direct_purchase.year}"
  end

  def message
    if items_count > 1
      'Pedimos fornecer-nos os materiais e ou execução dos serviços abaixo discriminados, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    else
      'Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    end
  end

  def pluralized_period_unit
    return unless component.direct_purchase && component.period

    if component.period > 1
      I18n.translate("enumerations.period_unit.#{period_unit}")
    else
      component.period_unit_humanize
    end
  end

  def signatures_grouped
    component.signatures.in_groups_of(4, false)
  end
end
