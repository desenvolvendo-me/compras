class RemoveAddressTicketIdFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :address_ticket_id
  end
end
