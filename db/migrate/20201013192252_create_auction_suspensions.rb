class CreateAuctionSuspensions < ActiveRecord::Migration
  def change
    create_table :compras_auction_suspensions do |t|
      t.integer :auction_id
      t.date    :suspension_date
      t.integer :responsible_suspension_id
      t.text    :suspension_reason
      t.date    :reactivation_date
      t.integer :responsible_reactivation_id
      t.text    :reactivation_reason
      t.timestamps
    end

    add_index :compras_auction_suspensions, :auction_id,
              name: :auction_suspensions_auction_index
    add_foreign_key :compras_auction_suspensions, :compras_auctions, column: :auction_id,
                    name: :auction_suspensions_auction_fk

    add_index :compras_auction_suspensions, :responsible_suspension_id,
              name: :auction_responsible_suspension_index
    add_foreign_key :compras_auction_suspensions, :compras_users, column: :responsible_suspension_id,
                    name: :auction_responsible_suspension_fk

    add_index :compras_auction_suspensions, :responsible_reactivation_id,
              name: :auction_responsible_reactivation_index
    add_foreign_key :compras_auction_suspensions, :compras_users, column: :responsible_reactivation_id,
                    name: :auction_responsible_reactivation_fk
  end

end
