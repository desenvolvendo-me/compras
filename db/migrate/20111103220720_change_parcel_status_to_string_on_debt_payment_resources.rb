class ChangeParcelStatusToStringOnDebtPaymentResources < ActiveRecord::Migration
  def change
    remove_index :debt_payment_resources, :parcel_status
    remove_column :debt_payment_resources, :parcel_status
    add_column :debt_payment_resources, :parcel_status, :string
  end
end
