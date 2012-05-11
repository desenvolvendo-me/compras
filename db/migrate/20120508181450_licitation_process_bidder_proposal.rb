class LicitationProcessBidderProposal < ActiveRecord::Migration
  def up
    create_table :licitation_process_bidder_proposals do |t|
      t.references :licitation_process_bidder
      t.references :administrative_process_budget_allocation_item
      t.decimal :unit_price, :precision => 10, :scale => 2
      t.string :brand
      t.integer :situation
      t.string :classification
    end

    add_index :licitation_process_bidder_proposals, :licitation_process_bidder_id, :name => :index_lpbp_on_licitation_process_bidder_id
    add_index :licitation_process_bidder_proposals, :administrative_process_budget_allocation_item_id, :name => :index_lpbp_on_administrative_process_budget_allocation_item_id

    add_foreign_key :licitation_process_bidder_proposals, :licitation_process_bidders, :name => :licitation_process_bidder_id_fk
    add_foreign_key :licitation_process_bidder_proposals, :administrative_process_budget_allocation_items, :name => :administrative_process_budget_allocation_item_id_fk
  end

  def down
    drop_table :licitation_process_bidder_proposals
  end
end
