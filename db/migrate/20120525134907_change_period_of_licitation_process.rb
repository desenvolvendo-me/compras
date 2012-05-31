class ChangePeriodOfLicitationProcess < ActiveRecord::Migration
  def change
    remove_column :licitation_processes, :period_id

    add_column :licitation_processes, :period, :integer
    add_column :licitation_processes, :period_unit, :string
  end
end
