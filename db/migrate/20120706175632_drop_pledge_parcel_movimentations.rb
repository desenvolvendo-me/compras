class DropPledgeParcelMovimentations < ActiveRecord::Migration
  def change
    drop_table :compras_pledge_parcel_movimentations
  end
end
