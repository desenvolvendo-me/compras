class CreateTceSpecificationCapabilities < ActiveRecord::Migration
  def change
    create_table :compras_tce_specification_capabilities do |t|
      t.string :description
      t.references :capability_source
      t.references :application_code

      t.timestamps
    end

    add_index :compras_tce_specification_capabilities, :capability_source_id,
              :name => :index_tcesc_capability_source_id
    add_index :compras_tce_specification_capabilities, :application_code_id,
              :name => :index_tcesc_application_code_id

    add_foreign_key :compras_tce_specification_capabilities , :compras_capability_sources,
                    :column => :capability_source_id #, :name => :tcesc_capability_source_fk
    add_foreign_key :compras_tce_specification_capabilities , :compras_application_codes,
                    :column => :application_code_id #, :name => :tcesc_application_code_fk
  end
end
