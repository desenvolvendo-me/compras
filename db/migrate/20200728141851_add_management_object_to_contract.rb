class AddManagementObjectToContract < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :management_object_id, :integer

    add_index :compras_contracts, :management_object_id
    add_foreign_key :compras_contracts, :compras_management_objects, column: :management_object_id
  end
end
