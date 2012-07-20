# encoding: utf-8
class AdministrativeProcessDecorator
  include Decore
  include Decore::Proxy
  include Decore::Routes
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper
  include ActionView::Helpers::UrlHelper

  def value_estimated
    number_to_currency(super)
  end

  def total_allocations_value
    number_with_precision(super)
  end

  def build_licitation_process_link
    return unless component.persisted? && component.released? && component.allow_licitation_process?

    if component.licitation_process.nil?
      link_to('Novo processo licitatório',  routes.new_licitation_process_path(:administrative_process_id => component.id), :class => "button primary")
    else
      link_to('Editar processo licitatório',  routes.edit_licitation_process_path(component.licitation_process, :administrative_process_id => component.id), :class => "button secondary")
    end
  end

  def release_button
    return unless component.persisted?

    if component.waiting?
      link_to('Liberar', routes.new_administrative_process_liberation_path(:administrative_process_id => component.id), :class => 'button primary')
    elsif component.released? && component.administrative_process_liberation
      link_to('Liberação', routes.edit_administrative_process_liberation_path(component.administrative_process_liberation), :class => 'button secondary')
    end
  end

  def date
    localize super if super
  end
end
