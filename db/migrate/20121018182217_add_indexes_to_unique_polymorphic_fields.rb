class AddIndexesToUniquePolymorphicFields < ActiveRecord::Migration
  def change
    add_index :compras_creditors, [:creditable_id, :creditable_type], :unique => true

    add_index :compras_resource_annuls, [:annullable_id, :annullable_type], :name => 'cra_annullable_id_annullable_type', :unique => true

    remove_index :compras_users, :name => 'index_compras_users_on_authenticable_id_and_authenticable_type'

    add_index :compras_users, [:authenticable_id, :authenticable_type], :unique => true
  end
end
