class RemoveColumnBranchActivitiesAllowTaxDeduction < ActiveRecord::Migration
  def change
    remove_column :branch_activities, :allow_tax_deduction
  end
end
