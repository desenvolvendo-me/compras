class RemoveColumnStatusInBidders < ActiveRecord::Migration
  def change
    remove_column :compras_bidders, :status
    remove_column :compras_bidders, :will_submit_new_proposal_when_draw
  end
end
