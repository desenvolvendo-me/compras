class CreateContractTerminations < ActiveRecord::Migration
  def change
    create_table :compras_contract_terminations do |t|
      t.integer :number
      t.integer :year
      t.references :contract
      t.text :reason
      t.date :termination_date
      t.date :expiry_date
      t.date :publication_date
      t.references :dissemination_source
      t.decimal :fine_value, :precision => 10, :scale => 2
      t.decimal :compensation_value, :precision => 10, :scale => 2
      t.string :term_termination_file

      t.timestamps
    end

    add_index :compras_contract_terminations, :contract_id
    add_index :compras_contract_terminations, :dissemination_source_id

    add_foreign_key :compras_contract_terminations, :compras_contracts, :column => :contract_id
    add_foreign_key :compras_contract_terminations, :compras_dissemination_sources, :column => :dissemination_source_id
  end
end
