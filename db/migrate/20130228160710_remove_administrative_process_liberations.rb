class RemoveAdministrativeProcessLiberations < ActiveRecord::Migration
  def change
    drop_table :compras_administrative_process_liberations
  end
end
