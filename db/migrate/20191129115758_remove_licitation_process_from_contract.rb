class RemoveLicitationProcessFromContract < ActiveRecord::Migration
  remove_column :compras_contracts,:licitation_process
end
