class CreateTableComprasSignatureConfigurationItems < ActiveRecord::Migration
  def change
    create_table "compras_signature_configuration_items" do |t|
      t.integer  "signature_configuration_id"
      t.integer  "signature_id"
      t.integer  "order"
      t.datetime "created_at",                 :null => false
      t.datetime "updated_at",                 :null => false
    end

    add_index "compras_signature_configuration_items", ["signature_configuration_id"], :name => "csci_signature_configuration_id"
    add_index "compras_signature_configuration_items", ["signature_id"], :name => "csci_signature_id"
  end
end
