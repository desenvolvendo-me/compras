class MovePledgeTypeFromLicitationProcessBudgetAllocationsToLicitationProcess < ActiveRecord::Migration
  class LicitationProcess < ActiveRecord::Base
  end

  def change
    add_column :licitation_processes, :pledge_type, :string

    LicitationProcess.all.each do |licitation_process|
      begin
        licitation_process.update_attributes! :pledge_type => licitation_process.licitation_process_budget_allocations.first.try(:pledge_type) || 'Estimativo'
      rescue
      end
    end

    remove_column :licitation_process_budget_allocations, :pledge_type
  end
end
