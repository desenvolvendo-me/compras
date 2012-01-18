class RemoveColumnCnaeIdIdFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_index :economic_registrations, :cnae_id
    remove_foreign_key :economic_registrations, :cnaes
    remove_column :economic_registrations, :cnae_id
  end

  def down
    add_index :economic_registrations, :cnae_id
    add_foreign_key :economic_registrations, :cnaes
    add_column :economic_registrations, :cnae_id, :integer
  end
end
