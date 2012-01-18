class CreateLowerPayments < ActiveRecord::Migration
  def change
    create_table :lower_payments do |t|
      t.integer :person_id

      t.timestamps
    end

    add_index :lower_payments, :person_id
    add_foreign_key :lower_payments, :people
  end
end
