class CreateTypeMovementEconomicRegistrations < ActiveRecord::Migration
  def change
    create_table :type_movement_economic_registrations do |t|
      t.string :name
      t.string :acronym

      t.timestamps
    end
  end
end
