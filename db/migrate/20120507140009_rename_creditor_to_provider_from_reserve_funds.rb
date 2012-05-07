class RenameCreditorToProviderFromReserveFunds < ActiveRecord::Migration
  def change
    rename_column :reserve_funds, :creditor_id, :provider_id

    rename_index :reserve_funds, :index_reserve_funds_on_creditor_id, :index_reserve_funds_on_provider_id

    remove_foreign_key :reserve_funds, :name => :reserve_funds_creditor_id_fk

    add_foreign_key :reserve_funds, :providers

    ReserveFund.update_all(:provider_id => nil)
  end
end
