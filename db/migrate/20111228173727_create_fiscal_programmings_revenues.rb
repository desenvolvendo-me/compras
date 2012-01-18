class CreateFiscalProgrammingsRevenues < ActiveRecord::Migration
  def change
    create_table :fiscal_programmings_revenues, :id => false do |t|
      t.integer :fiscal_programming_id
      t.integer :revenue_id
    end
    add_index :fiscal_programmings_revenues, :fiscal_programming_id
    add_index :fiscal_programmings_revenues, :revenue_id
    add_foreign_key :fiscal_programmings_revenues, :fiscal_programmings
    add_foreign_key :fiscal_programmings_revenues, :revenues
  end
end
