# encoding: utf-8
class SupplyAuthorizationPresenter < Presenter::Proxy
  def date
    helpers.l object.date
  end

  def message
    if items_count > 1
      'Pedimos fornecer-nos os materiais e ou execução dos serviços abaixo discriminados, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    else
      'Pedimos fornecer-nos o material e ou execução do serviço abaixo discriminado, respeitando as especificações e condições constantes nesta autorização de fornecimento.'
    end
  end
end
