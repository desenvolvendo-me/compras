class AddNewFieldsToContracts < ActiveRecord::Migration
  def change
    change_table :compras_contracts do |t|
      t.integer    :sequential_number
      t.integer    :parent_id
      t.date       :publication_date
      t.references :dissemination_source
      t.text       :content
      t.references :creditor
      t.references :service_or_contract_type
      t.string     :execution_type
      t.string     :contract_guarantees
      t.decimal    :contract_value,  :precision => 10, :scale => 2
      t.decimal    :guarantee_value, :precision => 10, :scale => 2
      t.integer    :contract_validity
      t.string     :subcontracting
      t.date       :cancellation_date
      t.string     :cancellation_reason
      t.references :licitation_process
      t.references :direct_purchase
      t.references :budget_structure
      t.integer    :budget_structure_responsible_id
      t.integer    :lawyer_id
      t.string     :lawyer_code
    end

    add_index :compras_contracts, :sequential_number
    add_index :compras_contracts, :parent_id
    add_index :compras_contracts, :dissemination_source_id
    add_index :compras_contracts, :creditor_id
    add_index :compras_contracts, :service_or_contract_type_id
    add_index :compras_contracts, :licitation_process_id
    add_index :compras_contracts, :direct_purchase_id
    add_index :compras_contracts, :budget_structure_id
    add_index :compras_contracts, :budget_structure_responsible_id
    add_index :compras_contracts, :lawyer_id

    add_foreign_key :compras_contracts, :compras_contracts, :column => :parent_id
    add_foreign_key :compras_contracts, :compras_dissemination_sources, :column => :dissemination_source_id
    add_foreign_key :compras_contracts, :compras_creditors, :column => :creditor_id
    add_foreign_key :compras_contracts, :compras_service_or_contract_types, :column => :service_or_contract_type_id
    add_foreign_key :compras_contracts, :compras_licitation_processes, :column => :licitation_process_id
    add_foreign_key :compras_contracts, :compras_direct_purchases, :column => :direct_purchase_id
    add_foreign_key :compras_contracts, :compras_budget_structures, :column => :budget_structure_id
    add_foreign_key :compras_contracts, :compras_employees, :column => :budget_structure_responsible_id
    add_foreign_key :compras_contracts, :compras_employees, :column => :lawyer_id
  end
end
