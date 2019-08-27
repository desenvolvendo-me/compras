class CreateBatchMaterials < ActiveRecord::Migration
  def change
    create_table :compras_batch_materials do |t|
      t.string :description
      t.references :demand_batch

      t.timestamps
    end
    add_index :compras_batch_materials, :demand_batch_id
  end
end
