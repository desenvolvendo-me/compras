class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :compras_programs do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
