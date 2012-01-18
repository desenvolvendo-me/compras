class CreateActiveDebtStatusMovimentations < ActiveRecord::Migration
  def change
    create_table :active_debt_status_movimentations do |t|
      t.references :active_debt
      t.references :active_debt_status_modification

      t.timestamps
    end
    add_index :active_debt_status_movimentations, :active_debt_id
    add_index :active_debt_status_movimentations, :active_debt_status_modification_id, :name => 'index_active_debt_movimentations_on_active_debt_modification'

    add_foreign_key :active_debt_status_movimentations, :active_debts
    add_foreign_key :active_debt_status_movimentations, :active_debt_status_modifications, :name => "active_debt_movimentations_on_active_debt_modification_fk"
  end
end
