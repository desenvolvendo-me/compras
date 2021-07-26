class CreateCapabilityDestinationDetails < ActiveRecord::Migration
  def change
    create_table :compras_capability_destination_details do |t|
      t.references :capability_destination
      t.references :capability_allocation_detail
      t.string :status

      t.timestamps
    end

    add_index :compras_capability_destination_details, :capability_destination_id, :name => :ccdd_cd_id
    add_index :compras_capability_destination_details, :capability_allocation_detail_id, :name => :cdd_cad_id

    add_foreign_key :compras_capability_destination_details, :compras_capability_destinations,
                    :column => :capability_destination_id, :name => :ccdd_ccd_fk

    add_foreign_key :compras_capability_destination_details, :compras_capability_allocation_details,
                    :column => :capability_allocation_detail_id, :name => :ccdd_cad_fk
  end
end
