class CreateServicePublicCalculations < ActiveRecord::Migration
  def change
    create_table :service_public_calculations do |t|
      t.string :name
      t.decimal :value, :precision => 5, :scale => 2
      t.references :reference_unit
      t.references :type_public_service

      t.timestamps
    end
    add_index :service_public_calculations, :reference_unit_id
    add_index :service_public_calculations, :type_public_service_id
    add_foreign_key :service_public_calculations, :reference_units
    add_foreign_key :service_public_calculations, :type_public_services
  end
end
