class RenameAutoConvocationToInvitedFromLicitationProcessBidder < ActiveRecord::Migration
  def change
    rename_column :licitation_process_bidders, :auto_convocation, :invited
  end
end
