class LicitationProcessPresenter < Presenter::Proxy
  attr_modal :process, :year, :process_date, :licitation_number, :administrative_process

  def envelope_delivery_time
    helpers.l(object.envelope_delivery_time, :format => :hour) if object.envelope_delivery_time
  end

  def envelope_opening_time
    helpers.l(object.envelope_opening_time, :format => :hour) if object.envelope_opening_time
  end

  def build_accreditation_link
    return unless object.persisted?

    if object.accreditation
      helpers.link_to('Editar credenciamento',  routes.edit_licitation_process_accreditation_path(object), :class => "button secondary")
    else
      helpers.link_to('Novo credenciamento',  routes.new_licitation_process_accreditation_path(object), :class => "button primary")
    end
  end

  def invited_bidders_link
    helpers.link_to('Licitantes convidados', routes.licitation_process_licitation_process_invited_bidders_path(object), :class => "button primary")
  end

  def count_link
    helpers.link_to('Apurar', '#', :class => "button primary") if object.can_count?
  end
end
