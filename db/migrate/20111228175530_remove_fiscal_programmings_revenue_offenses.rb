class RemoveFiscalProgrammingsRevenueOffenses < ActiveRecord::Migration
  def change
    remove_index :fiscal_programmings_revenue_offenses, :name => :fpro_fiscal_programming_id
    remove_index :fiscal_programmings_revenue_offenses, :name => :fpro_revenue_offense_id
    remove_foreign_key :fiscal_programmings_revenue_offenses, :name => :fpro_fiscal_programming_fk
    remove_foreign_key :fiscal_programmings_revenue_offenses, :name => :fpro_revenue_offense_fk
    drop_table :fiscal_programmings_revenue_offenses
  end
end
