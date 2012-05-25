class ChangePeriodFromDirectPurchase < ActiveRecord::Migration
  def change
    remove_column :direct_purchases, :period_id

    add_column :direct_purchases, :period, :integer
    add_column :direct_purchases, :period_unit, :string
  end
end
