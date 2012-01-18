class RemoveCondominiumIdFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_foreign_key :economic_registrations, :condominiums
    remove_index :economic_registrations, :condominium_id
    remove_column :economic_registrations, :condominium_id
  end

  def down
    add_column :economic_registrations, :condominium_id, :integer
    add_foreign_key :economic_registrations, :condominiums
    add_index :economic_registrations, :condominium_id
  end
end
