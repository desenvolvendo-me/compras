class AddFieldsToPledge < ActiveRecord::Migration
  def change
    add_column :pledges, :expense_kind_id, :integer
    add_column :pledges, :pledge_historic_id, :integer
    add_column :pledges, :management_contract_id, :integer
    add_column :pledges, :licitation_modality_id, :integer
    add_column :pledges, :licitation_number, :string
    add_column :pledges, :licitation_year, :string
    add_column :pledges, :process_number, :string
    add_column :pledges, :process_year, :string
    add_column :pledges, :description, :text

    add_index :pledges, :expense_kind_id
    add_index :pledges, :pledge_historic_id
    add_index :pledges, :management_contract_id
    add_index :pledges, :licitation_modality_id

    add_foreign_key :pledges, :expense_kinds
    add_foreign_key :pledges, :pledge_historics
    add_foreign_key :pledges, :management_contracts
    add_foreign_key :pledges, :licitation_modalities
  end
end
