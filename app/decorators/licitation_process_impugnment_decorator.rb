class LicitationProcessImpugnmentDecorator < Decorator
  def licitation_process_envelope_delivery_date
    helpers.l(component.licitation_process_envelope_delivery_date) if component.licitation_process_envelope_delivery_date
  end

  def licitation_process_envelope_opening_date
    helpers.l(component.licitation_process_envelope_opening_date) if component.licitation_process_envelope_opening_date
  end

  def licitation_process_envelope_delivery_time
    helpers.l(component.licitation_process_envelope_delivery_time, :format => :hour) if component.licitation_process_envelope_delivery_time
  end

  def licitation_process_envelope_opening_time
    helpers.l(component.licitation_process_envelope_opening_time, :format => :hour) if component.licitation_process_envelope_opening_time
  end
end
