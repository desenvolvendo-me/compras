class RemoveLicitationAndProcessFieldsFromPledge < ActiveRecord::Migration
  def change
    remove_column :pledges, :licitation_number
    remove_column :pledges, :licitation_year
    remove_column :pledges, :process_number
    remove_column :pledges, :process_year
  end
end
