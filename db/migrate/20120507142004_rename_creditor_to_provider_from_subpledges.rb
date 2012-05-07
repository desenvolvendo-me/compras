class RenameCreditorToProviderFromSubpledges < ActiveRecord::Migration
  def change
    rename_column :subpledges, :creditor_id, :provider_id

    rename_index :subpledges, :index_subpledges_on_creditor_id, :index_subpledges_on_provider_id

    remove_foreign_key :subpledges, :name => :subpledges_creditor_id_fk

    add_foreign_key :subpledges, :providers

    Subpledge.update_all(:provider_id => nil)
  end
end
