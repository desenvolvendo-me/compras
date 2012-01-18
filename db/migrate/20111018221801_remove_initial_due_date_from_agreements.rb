class RemoveInitialDueDateFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :initial_due_date
  end
end
