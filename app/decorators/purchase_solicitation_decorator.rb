# encoding: utf-8
class PurchaseSolicitationDecorator < Decorator
  attr_modal :accounting_year, :kind, :delivery_location_id, :budget_structure_id

  def summary
    "Estrutura orçamentaria solicitante: #{budget_structure} / Responsável pela solicitação: #{responsible} / Status: #{service_status_humanize}"
  end
end
