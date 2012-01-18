class RemoveCoordinatesFromAddresses < ActiveRecord::Migration
  def change
    remove_columns :addresses, :latitude, :longitude
  end
end
