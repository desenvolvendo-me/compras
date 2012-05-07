class LicitationProcessDecorator < Decorator
  attr_modal :process, :year, :process_date, :licitation_number, :administrative_process

  def envelope_delivery_time
    helpers.l(component.envelope_delivery_time, :format => :hour) if component.envelope_delivery_time
  end

  def envelope_opening_time
    helpers.l(component.envelope_opening_time, :format => :hour) if component.envelope_opening_time
  end

  def build_accreditation_link
    return unless component.persisted?

    if component.accreditation
      helpers.link_to('Editar credenciamento',  routes.edit_licitation_process_accreditation_path(component), :class => "button secondary")
    else
      helpers.link_to('Novo credenciamento',  routes.new_licitation_process_accreditation_path(component), :class => "button primary")
    end
  end

  def bidders_link
    helpers.link_to('Licitantes', routes.licitation_process_licitation_process_bidders_path(component), :class => "button primary")
  end

  def count_link
    helpers.link_to('Apurar', '#', :class => "button primary") if component.envelope_opening?
  end

  def lots_link
    helpers.link_to('Lotes de itens', routes.licitation_process_licitation_process_lots_path(component), :class => "button primary")
  end
end
