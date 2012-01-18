class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :code
      t.string :digit
      t.string :name
      t.references :state

      t.timestamps
    end
    add_index :cities, :state_id
    add_foreign_key :cities, :states
  end
end
