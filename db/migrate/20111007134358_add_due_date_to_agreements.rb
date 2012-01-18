class AddDueDateToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :due_date, :date
  end
end
