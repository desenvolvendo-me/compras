class RenameCreditorToProviderFromPledge < ActiveRecord::Migration
  def change
    remove_column :pledges, :creditor_id

    add_column :pledges, :provider_id, :integer

    add_index :pledges, :provider_id

    add_foreign_key :pledges, :providers
  end
end
