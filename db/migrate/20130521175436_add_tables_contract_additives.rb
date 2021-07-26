class AddTablesContractAdditives < ActiveRecord::Migration
  def change
    create_table :compras_contract_additives do |t|
      t.references :contract
      t.string     :number, null: false
      t.string     :additive_type, null: false
      t.date       :signature_date, null: false
      t.date       :end_date, null: true
      t.date       :publication_date, null: false
      t.integer    :dissemination_source_id, null: false
      t.decimal    :value, precision: 10, scale: 2, null: true
      t.string     :observation

      t.timestamps
    end

    add_index :compras_contract_additives, :contract_id

    add_foreign_key :compras_contract_additives,
      :compras_contracts,
      column: :contract_id

    add_foreign_key :compras_contract_additives,
      :compras_dissemination_sources,
      column: :dissemination_source_id
  end
end
