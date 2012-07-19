class LicitationProcessDecorator < Decorator
  attr_modal :process, :year, :process_date, :licitation_number, :administrative_process_id

  def envelope_delivery_time
    helpers.l(super, :format => :hour) if super
  end

  def envelope_opening_time
    helpers.l(super, :format => :hour) if super
  end

  def parent_url(parent)
    if parent
      routes.edit_administrative_process_path(parent)
    else
      routes.licitation_processes_path
    end
  end

  def winner_proposal_total_price
    helpers.number_to_currency super if super
  end
end
