class RenameExpenseNatureTableToComprasPrefix < ActiveRecord::Migration
  def change
    if Rails.env == 'development' || Rails.env == 'test'
      rename_table :accounting_expense_natures, :compras_expense_natures
    end
  end
end
