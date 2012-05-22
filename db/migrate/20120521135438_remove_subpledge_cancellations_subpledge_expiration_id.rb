class RemoveSubpledgeCancellationsSubpledgeExpirationId < ActiveRecord::Migration
  def change
    remove_column :subpledge_cancellations, :subpledge_expiration_id
  end
end
