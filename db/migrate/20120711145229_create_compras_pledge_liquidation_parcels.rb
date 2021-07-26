class CreateComprasPledgeLiquidationParcels < ActiveRecord::Migration
  def change
    create_table :compras_pledge_liquidation_parcels do |t|
      t.references :pledge_liquidation
      t.integer :number
      t.decimal :value, :precision => 10, :scale => 2

      t.timestamps
    end

    add_foreign_key :compras_pledge_liquidation_parcels, :compras_pledge_liquidations, :column => :pledge_liquidation_id
    add_index :compras_pledge_liquidation_parcels, :pledge_liquidation_id, :name => :index_cplp_pledge_on_liquidation_id
  end
end
