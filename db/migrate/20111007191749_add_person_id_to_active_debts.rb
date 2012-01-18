class AddPersonIdToActiveDebts < ActiveRecord::Migration
  def change
    add_column :active_debts, :person_id, :integer
    add_index  :active_debts, :person_id
    add_foreign_key :active_debts, :people
  end
end
