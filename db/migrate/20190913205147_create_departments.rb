class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :compras_departments do |t|
      t.string :departments_group_id
      t.string :description
      t.string :class_number
      t.boolean :imported
      t.boolean :has_children
      t.string :masked_number
      t.string :mask

      t.timestamps
    end
    add_index "compras_departments", ["departments_group_id"], :name => "cmc_departments_group_id"
  end
end
