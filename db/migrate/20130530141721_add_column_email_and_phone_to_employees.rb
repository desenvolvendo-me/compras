class AddColumnEmailAndPhoneToEmployees < ActiveRecord::Migration
  def change
    add_column :compras_employees, :email, :string
    add_column :compras_employees, :phone, :string, limit: 14
  end
end
