class AddPositionIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :position_id, :integer

    add_index :employees, :position_id

    add_foreign_key :employees, :positions
  end
end
