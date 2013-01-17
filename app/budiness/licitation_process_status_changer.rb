class LicitationProcessStatusChanger
  def initialize(licitation_process)
    @licitation_process = licitation_process
  end

  def in_progress!
    return if @licitation_process.in_progress?

    @licitation_process.update_status(LicitationProcessStatus::IN_PROGRESS)
  end

  private

  attr_reader :licitation_process
end
