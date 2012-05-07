class RenameCreditorToProviderFromPledge < ActiveRecord::Migration
  def change
    rename_column :pledges, :creditor_id, :provider_id

    rename_index :pledges, :index_pledges_on_creditor_id, :index_pledges_on_provider_id

    remove_foreign_key :pledges, :name => :pledges_creditor_id_fk

    add_foreign_key :pledges, :providers

    Pledge.update_all(:provider_id => nil)
  end
end
