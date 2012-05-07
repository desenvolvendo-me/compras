# encoding: utf-8
class SupplyAuthorizationDecorator < Decorator
  def date
    helpers.l component.date
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
end
