# encoding: utf-8
module AdministrativeProcessesHelper
  def build_licitation_process_link
    return unless resource.persisted? && resource.released? && resource.allow_licitation_process?

    if resource.licitation_process.nil?
      link_to('Novo processo licitatório', new_licitation_process_path(:administrative_process_id => resource.id), :class => "button primary")
    else
      link_to('Editar processo licitatório', edit_licitation_process_path(resource.licitation_process, :administrative_process_id => resource.id), :class => "button secondary")
    end
  end

  def release_button
    return unless resource.persisted?

    if resource.waiting?
      link_to('Liberar', new_administrative_process_liberation_path(:administrative_process_id => resource.id), :class => 'button primary')
    elsif resource.released? && resource.administrative_process_liberation
      link_to('Liberação', edit_administrative_process_liberation_path(resource.administrative_process_liberation), :class => 'button secondary')
    end
  end

end
