class AddIdToParcelRevenues < ActiveRecord::Migration
  def change
    add_column :parcel_revenues, :id, :primary_key
  end
end
