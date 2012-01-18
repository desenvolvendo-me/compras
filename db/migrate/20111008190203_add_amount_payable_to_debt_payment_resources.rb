class AddAmountPayableToDebtPaymentResources < ActiveRecord::Migration
  def change
    add_column :debt_payment_resources, :amount_payable, :decimal, :precision => 5, :scale => 2
  end
end
