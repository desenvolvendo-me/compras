class AddFieldsIntoCapabilities < ActiveRecord::Migration
  def change
    add_column :compras_capabilities, :capability_destination_id, :integer
    add_column :compras_capabilities, :tce_specification_capability_id, :integer

    add_index :compras_capabilities, :capability_destination_id, :name => :cp_cd_id
    add_index :compras_capabilities, :tce_specification_capability_id, :name => :cp_tsc_id

    add_foreign_key :compras_capabilities, :compras_capability_destinations, :column => :capability_destination_id, :name => :cp_cd_fk
    add_foreign_key :compras_capabilities, :compras_tce_specification_capabilities, :column => :tce_specification_capability_id, :name => :cp_ctsc_fk
  end
end
