# encoding: utf-8
class PurchaseSolicitationDecorator < Decorator
  attr_modal :accounting_year, :kind, :delivery_location_id, :budget_structure_id

  def summary
    "Estrutura orçamentaria solicitante: #{budget_structure} / Responsável pela solicitação: #{responsible} / Status: #{service_status_humanize}"
  end

  def link_to_liberation
    return unless component.persisted?

    if component.pending?
      helpers.link_to("Liberar", routes.new_purchase_solicitation_liberation_path(:purchase_solicitation_id => component.id), :class => 'button primary')
    elsif component.liberated?
      helpers.link_to("Liberar", routes.edit_purchase_solicitation_liberation_path(:purchase_solicitation_id => component.id, :id => component.liberation.id), :class => 'button primary')
    end
  end
end
