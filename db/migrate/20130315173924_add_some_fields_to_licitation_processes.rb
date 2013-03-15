class AddSomeFieldsToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :minimum_bid_to_disposal, :decimal, :default => 0.0
    add_column :compras_licitation_processes, :concession_period, :integer
    add_column :compras_licitation_processes, :concession_period_unit, :string
    add_column :compras_licitation_processes, :goal, :text
    add_column :compras_licitation_processes, :licensor_rights_and_liabilities, :text
    add_column :compras_licitation_processes, :licensee_rights_and_liabilities, :text
  end
end
