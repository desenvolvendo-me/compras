class CreatePriceCollectionClassifications < ActiveRecord::Migration
  def change
    create_table :compras_price_collection_classifications do |t|
      t.string :classifiable_type
      t.integer :classifiable_id
      t.references :creditor
      t.decimal :unit_value, :precision => 10, :scale => 2
      t.decimal :total_value, :precision => 10, :scale => 2
      t.integer :classification

      t.timestamps
    end

    add_index :compras_price_collection_classifications, :creditor_id

    add_foreign_key :compras_price_collection_classifications, :compras_creditors, :column => :creditor_id
  end
end
