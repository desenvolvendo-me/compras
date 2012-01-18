class CreateActiveDebtStatusModifications < ActiveRecord::Migration
  def change
    create_table :active_debt_status_modifications do |t|
      t.string :year_range
      t.string :active_debt_range
      t.string :person_range
      t.string :revenue_range
      t.string :improvement_range
      t.date :due_date

      t.timestamps
    end
  end
end
