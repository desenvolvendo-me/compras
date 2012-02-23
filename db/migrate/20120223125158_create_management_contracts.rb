class CreateManagementContracts < ActiveRecord::Migration
  def change
    create_table :management_contracts do |t|
      t.integer :year
      t.references :entity
      t.string :contract_number
      t.string :process_number
      t.date :signature_date
      t.date :end_date
      t.text :description

      t.timestamps
    end
    add_index :management_contracts, :entity_id
    add_foreign_key :management_contracts, :entities
  end
end
