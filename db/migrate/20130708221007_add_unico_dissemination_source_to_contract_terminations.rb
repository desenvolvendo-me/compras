class AddUnicoDisseminationSourceToContractTerminations < ActiveRecord::Migration
  def change
    add_column :compras_contract_terminations, :dissemination_source_id, :integer

    add_index :compras_contract_terminations, :dissemination_source_id
    add_foreign_key :compras_contract_terminations, :unico_dissemination_sources, column: :dissemination_source_id
  end
end
