class RenameTablePersonIdentitiesToIndividualIdentities < ActiveRecord::Migration
  def up
    rename_table :person_identities, :individual_identities
  end

  def down
    rename_table :individual_identities, :person_identities
  end
end
