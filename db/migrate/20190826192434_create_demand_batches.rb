class CreateDemandBatches < ActiveRecord::Migration
  def change
    create_table :compras_demand_batches do |t|
      t.string :description
      t.references :demand

      t.timestamps
    end
    add_index :compras_demand_batches, :demand_id
  end
end
