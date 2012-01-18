class ChangeThePrecisionOfAmountPayableInDebtPaymentResources < ActiveRecord::Migration
  def up
    change_column :debt_payment_resources, :amount_payable, :decimal, :precision => 10, :scale => 2
  end

  def down
    change_column :debt_payment_resources, :amount_payable, :decimal, :precision => 5, :scale => 2
  end
end
