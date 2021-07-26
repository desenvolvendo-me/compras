class MigrateDataToStatusOfComprasAdministrativeProcesses < ActiveRecord::Migration
  def change
    LicitationProcess.find_each do |licitation_process|
      if licitation_process.licitation_process_ratifications.any?
        licitation_process.administrative_process.update_status(AdministrativeProcessStatus::APPROVED)
      end
    end
  end
end
