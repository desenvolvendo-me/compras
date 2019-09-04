class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :compras_departments do |t|
      t.string :name, null: false
      t.string :classification, null: false
      t.integer :parent_id, index: true
      t.integer :lft, index: true
      t.integer :rgt, index: true
      t.string :masked_number
      t.string :number
      t.timestamps
    end
  end
end
