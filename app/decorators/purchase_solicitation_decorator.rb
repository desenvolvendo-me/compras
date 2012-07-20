# encoding: utf-8
class PurchaseSolicitationDecorator < Decorator
  attr_modal :accounting_year, :kind, :delivery_location_id, :budget_structure_id

  def summary
    "Estrutura orçamentaria solicitante: #{budget_structure} / Responsável pela solicitação: #{responsible} / Status: #{service_status_humanize}"
  end

  def hide_liberation_button?
    (component.annulled? && component.liberation.nil?) || !component.persisted?
  end

  def liberation_url
    if component.pending?
      routes.new_purchase_solicitation_liberation_path(:purchase_solicitation_id => component.id)
    elsif component.liberated?
      routes.edit_purchase_solicitation_liberation_path(:purchase_solicitation_id => component.id, :id => component.liberation.id)
    end
  end

  def liberation_label
    if component.pending?
      'Liberar'
    elsif component.liberated?
      'Liberação'
    end
  end

  def quantity_by_material(material_id)
    helpers.number_with_precision(super(material_id)) if super
  end
end
