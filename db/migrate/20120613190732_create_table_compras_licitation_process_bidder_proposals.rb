class CreateTableComprasLicitationProcessBidderProposals < ActiveRecord::Migration
  def change
    create_table "compras_licitation_process_bidder_proposals" do |t|
      t.integer "licitation_process_bidder_id"
      t.integer "administrative_process_budget_allocation_item_id"
      t.decimal "unit_price",                                       :precision => 10, :scale => 2
      t.string  "brand"
      t.integer "situation"
      t.string  "classification"
    end

    add_index "compras_licitation_process_bidder_proposals", ["administrative_process_budget_allocation_item_id"], :name => "clpbp_administrative_process_budget_allocation_item_id"
    add_index "compras_licitation_process_bidder_proposals", ["licitation_process_bidder_id"], :name => "clpbp_licitation_process_bidder_id"
  end
end
