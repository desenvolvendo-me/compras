class LicitationProcessImpugnmentPresenter < Presenter::Proxy
  def licitation_process_envelope_delivery_date
    helpers.l(object.licitation_process_envelope_delivery_date) if object.licitation_process_envelope_delivery_date
  end

  def licitation_process_envelope_opening_date
    helpers.l(object.licitation_process_envelope_opening_date) if object.licitation_process_envelope_opening_date
  end

  def licitation_process_envelope_delivery_time
    helpers.l(object.licitation_process_envelope_delivery_time, :format => :hour) if object.licitation_process_envelope_delivery_time
  end

  def licitation_process_envelope_opening_time
    helpers.l(object.licitation_process_envelope_opening_time, :format => :hour) if object.licitation_process_envelope_opening_time
  end
end
