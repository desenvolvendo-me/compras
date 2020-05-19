class AddSecretaryToDepartment < ActiveRecord::Migration
  def change
    add_column :compras_departments, :secretary_id, :integer
    add_index :compras_departments, :secretary_id
    add_foreign_key :compras_departments, :compras_secretaries, column: :secretary_id
  end
end