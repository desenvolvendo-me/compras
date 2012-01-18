class ChangeDefaultForActiveDebtOnRevenues < ActiveRecord::Migration
  def change
    change_column_default :revenues, :active_debt, true
  end
end