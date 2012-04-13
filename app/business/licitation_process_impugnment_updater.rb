class LicitationProcessImpugnmentUpdater
  attr_accessor :licitation_process_impugnment

  def initialize(licitation_process_impugnment)
    self.licitation_process_impugnment = licitation_process_impugnment
  end

  def update_licitation_process_date!
    licitation_process = licitation_process_impugnment.licitation_process
    licitation_process.set_dates(
      :envelope_delivery_date => licitation_process_impugnment.new_envelope_delivery_date,
      :envelope_delivery_time => licitation_process_impugnment.new_envelope_delivery_time,
      :envelope_opening_date => licitation_process_impugnment.new_envelope_opening_date,
      :envelope_opening_time => licitation_process_impugnment.new_envelope_opening_time
    )
  end
end
