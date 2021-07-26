class CreateStructureAccountInformations < ActiveRecord::Migration
  def change
    create_table :compras_structure_account_informations do |t|
      t.string :name
      t.integer :tce_code
      t.references :capability_source

      t.timestamps
    end

    add_index :compras_structure_account_informations, :capability_source_id,
              :name => :index_csai_capability_source_id
    add_foreign_key :compras_structure_account_informations,
                    :compras_capability_sources,
                    :column => :capability_source_id
  end
end
