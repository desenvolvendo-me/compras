class DropTableAddressTickets < ActiveRecord::Migration
  def change
    drop_table :address_tickets
  end
end
