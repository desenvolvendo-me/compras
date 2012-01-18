class RemoveColumnListServiceIdFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_index :economic_registrations, :list_service_id
    remove_foreign_key :economic_registrations, :list_services
    remove_column :economic_registrations, :list_service_id
  end

  def down
    add_column :economic_registrations, :list_service_id, :integer
    add_index :economic_registrations, :list_service_id
    add_foreign_key :economic_registrations, :list_services
  end
end
