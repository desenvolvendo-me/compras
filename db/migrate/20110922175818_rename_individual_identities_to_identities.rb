class RenameIndividualIdentitiesToIdentities < ActiveRecord::Migration
  def change
    rename_table :individual_identities, :identities
  end
end
