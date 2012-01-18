class ChangeCurrentDefaultOnCurrencies < ActiveRecord::Migration
  def up
    change_column_default :currencies, :current, false
  end

  def down
    change_column_default :currencies, :current, nil
  end
end
