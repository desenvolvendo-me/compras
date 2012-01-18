class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|
      t.string :name
      t.integer :year
      t.text :body

      t.timestamps
    end
  end
end
