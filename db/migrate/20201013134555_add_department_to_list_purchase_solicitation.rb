class AddDepartmentToListPurchaseSolicitation < ActiveRecord::Migration
  def change
    add_column :compras_list_purchase_solicitations,:department_id, :integer
    add_index :compras_list_purchase_solicitations, :department_id
    add_foreign_key :compras_list_purchase_solicitations, :compras_departments,:column => :department_id
  end
end
