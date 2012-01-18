class RemoveDueDateFromDebtPaymentResources < ActiveRecord::Migration
  def up
    remove_column :debt_payment_resources, :due_date
  end

  def down
    add_column :debt_payment_resources, :due_date, :date
  end
end
