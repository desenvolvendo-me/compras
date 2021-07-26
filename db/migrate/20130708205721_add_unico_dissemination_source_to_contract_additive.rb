class AddUnicoDisseminationSourceToContractAdditive < ActiveRecord::Migration
  def change
    add_column :compras_contract_additives, :dissemination_source_id, :integer

    add_index :compras_contract_additives, :dissemination_source_id
    add_foreign_key :compras_contract_additives, :unico_dissemination_sources, column: :dissemination_source_id
  end
end
