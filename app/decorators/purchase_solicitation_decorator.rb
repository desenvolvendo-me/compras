# encoding: utf-8
class PurchaseSolicitationDecorator
  include Decore
  include Decore::Routes
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def summary
    "Estrutura orçamentaria solicitante: #{budget_structure} / Responsável pela solicitação: #{responsible} / Status: #{service_status_humanize}"
  end

  def quantity_by_material(material_id)
    number_with_precision super if super
  end
end
