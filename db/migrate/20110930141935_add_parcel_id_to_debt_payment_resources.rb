class AddParcelIdToDebtPaymentResources < ActiveRecord::Migration
  def change
    add_column :debt_payment_resources, :parcel_id, :integer
    add_index  :debt_payment_resources, :parcel_id
    add_foreign_key :debt_payment_resources, :parcels
  end
end
