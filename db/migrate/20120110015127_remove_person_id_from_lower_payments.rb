class RemovePersonIdFromLowerPayments < ActiveRecord::Migration
  def change
    remove_index :lower_payments, :person_id
    remove_foreign_key :lower_payments, :person
    remove_column :lower_payments, :person_id
  end
end
