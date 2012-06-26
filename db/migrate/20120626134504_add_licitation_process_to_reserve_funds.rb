class AddLicitationProcessToReserveFunds < ActiveRecord::Migration
  def change
    add_column :compras_reserve_funds, :licitation_process_id, :integer
    add_index :compras_reserve_funds, :licitation_process_id
    add_foreign_key :compras_reserve_funds, :compras_licitation_processes, :column => :licitation_process_id
  end
end
