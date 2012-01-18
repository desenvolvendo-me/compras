class CreateAddressTickets < ActiveRecord::Migration
  def change
    create_table :address_tickets do |t|
      t.string :name
      t.string :acronym

      t.timestamps
    end
  end
end
