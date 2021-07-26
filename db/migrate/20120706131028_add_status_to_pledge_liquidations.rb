class AddStatusToPledgeLiquidations < ActiveRecord::Migration
  def change
    add_column :compras_pledge_liquidations, :status, :string
  end
end
