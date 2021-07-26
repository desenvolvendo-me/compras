class ChangeCodeToIntegerOfSupplyAuthorizations < ActiveRecord::Migration
  def up
    change_column :compras_supply_authorizations, :code, :integer
  end

  def down
    change_column :compras_supply_authorizations, :code, :string
  end
end
