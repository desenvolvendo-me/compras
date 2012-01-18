class CreateActiveDebts < ActiveRecord::Migration
  def change
    create_table :active_debts do |t|
      t.string :year
      t.references :original_currency
      t.references :converted_currency
      t.references :responsible
      t.date :due_date
      t.date :fact_generator
      t.string :origin_process
      t.text :general_comment
      t.string :book
      t.string :book_year
      t.string :sheet
      t.string :position
      t.string :registration
      t.date :registration_date
      t.string :registration_year

      t.timestamps
    end
    add_index :active_debts, :original_currency_id
    add_index :active_debts, :converted_currency_id
    add_index :active_debts, :responsible_id
    add_foreign_key :active_debts, :currencies, :column => :original_currency_id
    add_foreign_key :active_debts, :currencies, :column => :converted_currency_id
    add_foreign_key :active_debts, :people, :column => :responsible_id
  end
end
