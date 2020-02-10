class AddUserToGeneratorSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_generator_supply_orders, :user_id, :integer
  end
end
