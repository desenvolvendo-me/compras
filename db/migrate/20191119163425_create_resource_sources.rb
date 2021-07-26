class CreateResourceSources < ActiveRecord::Migration
  def change
    create_table :compras_resource_sources do |t|
      t.string :name
      t.integer :year
      t.string :code
      t.integer :number_convention

      t.timestamps
    end
  end
end