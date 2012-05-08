class AddSubpledgeExpirationIdToSubpledgeCancellations < ActiveRecord::Migration
  def change
    add_column :subpledge_cancellations, :subpledge_expiration_id, :integer

    add_index :subpledge_cancellations, :subpledge_expiration_id

    add_foreign_key :subpledge_cancellations, :subpledge_expirations
  end
end
