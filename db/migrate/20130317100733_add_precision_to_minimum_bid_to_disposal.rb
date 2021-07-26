class AddPrecisionToMinimumBidToDisposal < ActiveRecord::Migration
  def change
    change_column :compras_licitation_processes, :minimum_bid_to_disposal, :decimal, :default => 0.0, :precision => 10, :scale => 3
  end
end
