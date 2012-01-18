class CreateFiscalYears < ActiveRecord::Migration
  def change
    create_table :fiscal_years do |t|
      t.integer :year

      t.timestamps
    end

    add_index :fiscal_years, :year, :unique => true
  end
end
