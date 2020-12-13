class AddLicitationProcessToAuction < ActiveRecord::Migration
  def change
    add_column :compras_auctions, :licitation_process_id, :integer

    add_index :compras_auctions, :licitation_process_id, name: :licitation_process_auction_index
    add_foreign_key :compras_auctions, :compras_licitation_processes,
                    column: :licitation_process_id, name: :licitation_process_auction_fk
  end
end
