class RenameCreditorToProviderFromPledge < ActiveRecord::Migration
  def change
    remove_column :pledges, :creditor_id

    add_column :pledges, :provider_id, :integer

    add_index :pledges, :index_pledges_on_provider_id

    add_foreign_key :pledges, :providers
  end
end
