class AddPercentageLimitToParticipateInBidsToTradings < ActiveRecord::Migration
  def change
    add_column :compras_tradings, :percentage_limit_to_participate_in_bids, :decimal, :precision => 5, :scale => 2, :default => 0.0
  end
end
