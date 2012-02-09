class ChangePurchaseSolicitationAccountingYearToInteger < ActiveRecord::Migration
  def change
    change_column :purchase_solicitations, :accounting_year, :integer
  end
end
