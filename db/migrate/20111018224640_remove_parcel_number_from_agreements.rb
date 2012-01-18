class RemoveParcelNumberFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :parcel_number
  end
end
