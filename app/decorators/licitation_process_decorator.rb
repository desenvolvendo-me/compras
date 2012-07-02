class LicitationProcessDecorator < Decorator
  attr_modal :process, :year, :process_date, :licitation_number, :administrative_process

  def envelope_delivery_time
    helpers.l(super, :format => :hour) if super
  end

  def envelope_opening_time
    helpers.l(super, :format => :hour) if super
  end

  def count_link
    return unless component.persisted?

    helpers.link_to('Apurar', routes.licitation_process_path(component), :class => "button primary") if component.envelope_opening?
  end

  def lots_link
    helpers.link_to('Lotes de itens', routes.licitation_process_lots_path(:licitation_process_id => component.id), :class => "button primary")
  end

  def winner_proposal_total_price
    helpers.number_to_currency super if super
  end
end
