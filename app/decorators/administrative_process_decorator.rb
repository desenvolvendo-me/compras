# encoding: utf-8
class AdministrativeProcessDecorator < Decorator
  attr_modal :year, :process, :protocol

  def value_estimated
    helpers.number_to_currency(component.value_estimated)
  end

  def total_allocations_value
    helpers.number_with_precision(component.total_allocations_value)
  end

  def build_licitation_process_link
    return unless component.persisted? && component.released? && component.allow_licitation_process?

    if component.licitation_process.nil?
      helpers.link_to('Novo processo licitatório',  routes.new_licitation_process_path(component), :class => "button primary")
    else
      helpers.link_to('Editar processo licitatório',  routes.edit_licitation_process_path(component.licitation_process), :class => "button secondary")
    end
  end

  def release_button
    return unless component.persisted?

    if component.waiting?
      helpers.link_to('Liberar', routes.new_administrative_process_liberation_path(:administrative_process_id => component.id), :class => 'button primary')
    elsif component.released? && component.administrative_process_liberation
      helpers.link_to('Liberação', routes.edit_administrative_process_liberation_path(component.administrative_process_liberation), :class => 'button secondary')
    end
  end
end
