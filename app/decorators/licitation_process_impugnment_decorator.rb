class LicitationProcessImpugnmentDecorator < Decorator
  def licitation_process_envelope_delivery_date
    helpers.l super if super
  end

  def licitation_process_envelope_opening_date
    helpers.l super if super
  end

  def licitation_process_envelope_delivery_time
    helpers.l(super, :format => :hour) if super
  end

  def licitation_process_envelope_opening_time
    helpers.l(super, :format => :hour) if super
  end
end
