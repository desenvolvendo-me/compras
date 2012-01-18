class AddRoomToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :room, :string
  end
end
