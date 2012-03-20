class AddProcessToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :licitation_processes, :process, :integer

    add_index :licitation_processes, [:process, :year], :unique => true
  end
end
