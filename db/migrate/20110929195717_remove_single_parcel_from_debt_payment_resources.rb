class RemoveSingleParcelFromDebtPaymentResources < ActiveRecord::Migration
  def up
    remove_column :debt_payment_resources, :single_parcel
  end

  def down
    add_column :debt_payment_resources, :single_parcel, :boolean, :default => false
  end
end
