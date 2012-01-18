class RemoveTributeDiscountValueFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :tribute_discount_value
  end
end
