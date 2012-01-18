class RemoveColumnCurrenciesCurrent < ActiveRecord::Migration
  def change
    remove_column :currencies, :current
  end
end
