class CreateAuctionSupportTeam < ActiveRecord::Migration
  def change
    create_table :compras_auction_support_teams do |t|
      t.integer :auction_id
      t.integer :employee_id
      t.timestamps
    end

    add_index :compras_auction_support_teams, :auction_id
    add_index :compras_auction_support_teams, :employee_id

    add_foreign_key :compras_auction_support_teams, :compras_auctions,
                column: :auction_id
    add_foreign_key :compras_auction_support_teams, :compras_employees,
                column: :employee_id
  end
end
