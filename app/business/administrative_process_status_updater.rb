class AdministrativeProcessStatusUpdater
  attr_accessor :administrative_process, :administrative_process_status

  def initialize(administrative_process, administrative_process_status = AdministrativeProcessStatus)
    self.administrative_process = administrative_process
    self.administrative_process_status = administrative_process_status
  end

  def release!
    administrative_process.update_status(released_status)
  end

  private

  def released_status
    administrative_process_status.value_for(:RELEASED)
  end
end
