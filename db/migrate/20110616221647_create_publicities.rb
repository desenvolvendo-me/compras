class CreatePublicities < ActiveRecord::Migration
  def change
    create_table :publicities do |t|
      t.string :name
      t.decimal :value, :precision => 10, :scale => 4
      t.references :periodicity

      t.timestamps
    end
    add_index :publicities, :periodicity_id
    add_foreign_key :publicities, :periodicities
  end
end
