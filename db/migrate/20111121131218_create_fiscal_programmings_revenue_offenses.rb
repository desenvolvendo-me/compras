class CreateFiscalProgrammingsRevenueOffenses < ActiveRecord::Migration
  def change
    create_table :fiscal_programmings_revenue_offenses, :id => false do |t|
      t.integer :fiscal_programming_id
      t.integer :revenue_offense_id
    end

    add_index :fiscal_programmings_revenue_offenses, :fiscal_programming_id, :name => :fpro_fiscal_programming_id
    add_index :fiscal_programmings_revenue_offenses, :revenue_offense_id, :name => :fpro_revenue_offense_id
    add_foreign_key :fiscal_programmings_revenue_offenses, :fiscal_programmings, :name => :fpro_fiscal_programming_fk
    add_foreign_key :fiscal_programmings_revenue_offenses, :revenue_offenses, :name => :fpro_revenue_offense_fk
  end
end
