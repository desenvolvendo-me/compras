class AddUnicoDisseminationSourceToContracts < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :dissemination_source_id, :integer

    add_index :compras_contracts, :dissemination_source_id
    add_foreign_key :compras_contracts, :unico_dissemination_sources, column: :dissemination_source_id
  end
end
