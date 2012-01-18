class RemoveDueDateFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :due_date
  end
end
