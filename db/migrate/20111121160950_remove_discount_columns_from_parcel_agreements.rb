class RemoveDiscountColumnsFromParcelAgreements < ActiveRecord::Migration
  def change
    remove_column :parcel_agreements, :discount_tribute_value
    remove_column :parcel_agreements, :discount_correction_value
    remove_column :parcel_agreements, :discount_interest_value
    remove_column :parcel_agreements, :discount_fine_value
  end
end
