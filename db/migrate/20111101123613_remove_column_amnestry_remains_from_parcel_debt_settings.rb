class RemoveColumnAmnestryRemainsFromParcelDebtSettings < ActiveRecord::Migration
  def change
    remove_column :parcel_debt_settings, :amnesty_remains
  end
end
