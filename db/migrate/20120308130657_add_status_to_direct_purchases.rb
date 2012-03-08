class AddStatusToDirectPurchases < ActiveRecord::Migration
  def change
    add_column :direct_purchases, :status, :string
  end
end
