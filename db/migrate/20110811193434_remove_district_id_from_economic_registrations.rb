class RemoveDistrictIdFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_index :economic_registrations, :district_id
    remove_foreign_key :economic_registrations, :districts
    remove_column :economic_registrations, :district_id
  end

  def down
    add_column :economic_registrations, :district_id, :integer
    add_foreign_key :economic_registrations, :districts
    add_index :economic_registrations, :district_id
  end
end
