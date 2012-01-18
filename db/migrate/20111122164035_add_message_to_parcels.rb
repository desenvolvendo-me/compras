class AddMessageToParcels < ActiveRecord::Migration
  def change
    add_column :parcels, :message, :text
  end
end
