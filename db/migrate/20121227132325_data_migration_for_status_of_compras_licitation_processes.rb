class DataMigrationForStatusOfComprasLicitationProcesses < ActiveRecord::Migration
  def change
    LicitationProcess.find_each do |licitation_process|
      if licitation_process.bidders.empty?
        licitation_process.update_column(:status, LicitationProcessStatus::WAITING_FOR_OPEN)
      else
        if licitation_process.ratification?
          licitation_process.update_column(:status, LicitationProcessStatus::APPROVED)
        else
          licitation_process.update_column(:status, LicitationProcessStatus::IN_PROGRESS)
        end
      end
    end
  end
end
