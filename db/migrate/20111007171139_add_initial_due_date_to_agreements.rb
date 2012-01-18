class AddInitialDueDateToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :initial_due_date, :date
  end
end
