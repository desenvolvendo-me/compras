class RenameCreditorToProviderFromReserveFunds < ActiveRecord::Migration
  def change
    remove_column :reserve_funds, :creditor_id

    add_column :reserve_funds, :provider_id, :integer

    add_index :reserve_funds, :index_reserve_funds_on_provider_id

    add_foreign_key :reserve_funds, :providers
end
