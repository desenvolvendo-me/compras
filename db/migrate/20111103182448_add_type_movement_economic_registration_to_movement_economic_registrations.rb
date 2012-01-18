class AddTypeMovementEconomicRegistrationToMovementEconomicRegistrations < ActiveRecord::Migration
  def change
    add_column :movement_economic_registrations, :type_movement_economic_registration, :string
  end
end
