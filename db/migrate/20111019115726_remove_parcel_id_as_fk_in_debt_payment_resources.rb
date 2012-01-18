class RemoveParcelIdAsFkInDebtPaymentResources < ActiveRecord::Migration
  def up
    remove_foreign_key :debt_payment_resources, :parcels
    rename_column :debt_payment_resources, :parcel_id, :parcel
  end

  def down
    rename_column :debt_payment_resources, :parcel, :parcel_id
    add_foreign_key :debt_payment_resources, :parcels
  end
end
