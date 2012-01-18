class AddParcelStatusToDebtPaymentResources < ActiveRecord::Migration
  def change
    add_column :debt_payment_resources, :parcel_status, :integer
    add_index  :debt_payment_resources, :parcel_status
  end
end
