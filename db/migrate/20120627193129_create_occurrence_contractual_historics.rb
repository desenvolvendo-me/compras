class CreateOccurrenceContractualHistorics < ActiveRecord::Migration
  def change
    create_table :compras_occurrence_contractual_historics do |t|
      t.references :contract
      t.string :occurrence_contractual_historic_type
      t.string :occurrence_contractual_historic_change
      t.date :occurrence_date
      t.text :observations
      t.integer :sequence

      t.timestamps
    end

    add_index :compras_occurrence_contractual_historics, :contract_id
    add_foreign_key :compras_occurrence_contractual_historics, :compras_contracts, :column => :contract_id
  end
end
