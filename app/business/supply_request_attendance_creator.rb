class SupplyRequestAttendanceCreator
  def initialize(supply_request, current_user)
    @supply_request = supply_request
    @current_user = current_user
  end


  def self.create!(*args)
    new(*args).create!
  end

  def create!
    if supply_request.updatabled
      finish_attendance
    else
      reopen_attendance
    end
  end

  private

  attr_reader :supply_request, :current_user

  def finish_attendance
    SupplyRequestAttendance.create(
        date: Date.today,
        justification: 'Finalização do pedido de atendimento.',
        responsible_id: current_user.id,
        supply_request_id: supply_request.id,
        service_status: SupplyRequestServiceStatus::FINISHED)
  end

  def reopen_attendance
    SupplyRequestAttendance.create(
        date: Date.today,
        justification: 'Reabertura do pedido de atendimento.',
        responsible_id: current_user.id,
        supply_request_id: supply_request.id,
        service_status: SupplyRequestServiceStatus::REOPEN)
  end
end
