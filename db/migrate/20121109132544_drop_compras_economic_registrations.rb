class DropComprasEconomicRegistrations < ActiveRecord::Migration
  def change
    drop_table :compras_economic_registrations
  end
end
