class RemoveRealTributeValueFromParcelAgreements < ActiveRecord::Migration
  def change
    remove_column :parcel_agreements, :real_tribute_value
  end
end
