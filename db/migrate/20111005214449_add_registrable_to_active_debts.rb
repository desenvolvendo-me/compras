class AddRegistrableToActiveDebts < ActiveRecord::Migration
  def change
    add_column :active_debts, :registrable_id, :integer
    add_column :active_debts, :registrable_type, :string

    add_index :active_debts, :registrable_id
  end
end
