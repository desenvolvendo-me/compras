class CreateSignatureConfigurationItems < ActiveRecord::Migration
  def change
    create_table :signature_configuration_items do |t|
      t.integer :signature_configuration_id
      t.integer :signature_id
      t.integer :order

      t.timestamps
    end

    add_index :signature_configuration_items, :signature_configuration_id, :name => :index_sci_signature_configuration_id
    add_index :signature_configuration_items, :signature_id

    add_foreign_key :signature_configuration_items, :signature_configurations
    add_foreign_key :signature_configuration_items, :signatures
  end
end
