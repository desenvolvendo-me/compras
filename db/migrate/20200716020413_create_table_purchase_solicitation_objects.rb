class CreateTablePurchaseSolicitationObjects < ActiveRecord::Migration
  def change
    create_table "compras_purchase_solicitation_objects" do |t|
      t.integer   "management_object_id"
      t.integer   "purchase_solicitation_id"
      t.timestamps
    end

    add_index :compras_purchase_solicitation_objects, :management_object_id, name: :management_object_index
    add_index :compras_purchase_solicitation_objects, :purchase_solicitation_id, name: :purchase_solicitation_index

    add_foreign_key :compras_purchase_solicitation_objects, :compras_management_objects,
                    column: :management_object_id, name: :management_object_fk
    add_foreign_key :compras_purchase_solicitation_objects, :compras_purchase_solicitations,
                    column: :purchase_solicitation_id, name: :purchase_solicitation_fk
  end
end
