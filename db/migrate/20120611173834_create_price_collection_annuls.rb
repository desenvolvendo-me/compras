class CreatePriceCollectionAnnuls < ActiveRecord::Migration
  def change
    create_table :price_collection_annuls do |t|
      t.references :price_collection
      t.references :employee
      t.date :date
      t.text :description
      t.string :annul_type

      t.timestamps
    end
    add_index :price_collection_annuls, :price_collection_id
    add_index :price_collection_annuls, :employee_id
  end
end
