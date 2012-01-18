class RemoveTypeMovementEconomicRegistrationIdFromMovementEconomicRegistrations < ActiveRecord::Migration
  def change
    remove_column :movement_economic_registrations, :type_movement_economic_registration_id
  end
end
