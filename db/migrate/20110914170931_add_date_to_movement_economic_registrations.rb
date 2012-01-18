class AddDateToMovementEconomicRegistrations < ActiveRecord::Migration
  def change
    add_column :movement_economic_registrations, :date, :date
  end
end
