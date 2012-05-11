class RenameCreditorToProviderFromSubpledges < ActiveRecord::Migration
  def change
    remove_column :subpledges, :creditor_id

    add_column :subpledges, :provider_id, :integer

    add_index :subpledges, :index_subpledges_on_provider_id

    add_foreign_key :subpledges, :providers
  end
end
