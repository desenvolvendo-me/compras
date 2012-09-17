class RenameTableLicitationProcessBiddersToBidders < ActiveRecord::Migration
  def change
    rename_table :compras_licitation_process_bidders, :compras_bidders
  end
end
