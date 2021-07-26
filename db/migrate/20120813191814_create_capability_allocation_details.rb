class CreateCapabilityAllocationDetails < ActiveRecord::Migration
  def change
    create_table :compras_capability_allocation_details do |t|
      t.string :description

      t.timestamps
    end
  end
end
