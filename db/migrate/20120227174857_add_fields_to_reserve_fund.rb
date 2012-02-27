class AddFieldsToReserveFund < ActiveRecord::Migration
  def change
    add_column :reserve_funds, :reserve_allocation_type_id, :integer
    add_column :reserve_funds, :licitation_modality_id, :integer
    add_column :reserve_funds, :creditor_id, :integer
    add_column :reserve_funds, :status, :string
    add_column :reserve_funds, :date, :date
    add_column :reserve_funds, :licitation_number, :string
    add_column :reserve_funds, :licitation_year, :string
    add_column :reserve_funds, :process_number, :string
    add_column :reserve_funds, :process_year, :string
    add_column :reserve_funds, :historic, :text

    add_index :reserve_funds, :reserve_allocation_type_id
    add_index :reserve_funds, :licitation_modality_id
    add_index :reserve_funds, :creditor_id

    add_foreign_key :reserve_funds, :reserve_allocation_types
    add_foreign_key :reserve_funds, :licitation_modalities
    add_foreign_key :reserve_funds, :creditors
  end
end
