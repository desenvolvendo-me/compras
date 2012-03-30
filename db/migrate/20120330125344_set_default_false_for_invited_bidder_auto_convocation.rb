class SetDefaultFalseForInvitedBidderAutoConvocation < ActiveRecord::Migration
  def change
    change_column :licitation_process_invited_bidders, :auto_convocation, :boolean, :default => false
  end
end
