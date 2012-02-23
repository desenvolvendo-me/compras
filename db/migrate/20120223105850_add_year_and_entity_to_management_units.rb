class AddYearAndEntityToManagementUnits < ActiveRecord::Migration
  def change
    add_column :management_units, :year, :integer
    add_column :management_units, :entity_id, :integer

    add_index :management_units, :entity_id
    add_foreign_key :management_units, :entities
  end
end
