class AddDueDateTwoToDebtPaymentResources < ActiveRecord::Migration
  def change
    add_column :debt_payment_resources, :due_date, :date
  end
end
