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
    return unless component.persisted? && component.released?

    if component.licitation_process.nil?
      helpers.link_to('Novo processo licitatório',  routes.new_licitation_process_path(component), :class => "button primary")
    else
      helpers.link_to('Editar processo licitatório',  routes.edit_licitation_process_path(component.licitation_process), :class => "button secondary")
    end
  end
end
