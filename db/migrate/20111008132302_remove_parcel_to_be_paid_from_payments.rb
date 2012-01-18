class RemoveParcelToBePaidFromPayments < ActiveRecord::Migration
  def up
    remove_column :payments, :parcel_to_be_paid
  end

  def down
    add_column :payments, :parcel_to_be_paid, :integer
  end
end
