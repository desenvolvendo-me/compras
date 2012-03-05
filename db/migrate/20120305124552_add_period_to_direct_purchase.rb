class AddPeriodToDirectPurchase < ActiveRecord::Migration
  def change
    add_column :direct_purchases, :period_id, :integer

    add_index :direct_purchases, :period_id
    add_foreign_key :direct_purchases, :periods
  end
end
