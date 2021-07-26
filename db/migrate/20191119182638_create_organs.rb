class CreateOrgans < ActiveRecord::Migration
  def change
    create_table :compras_organs do |t|
      t.string :name
      t.string :year
      t.string :code
      t.string :initial
      t.string :category

      t.timestamps
    end
  end
end
