class RenameColumnPersonIdInIdentityToIndividualId < ActiveRecord::Migration
  def up
    rename_column :individual_identities, :person_id, :individual_id
  end

  def down
    rename_column :individual_identities, :individual_id, :person_id
  end
end
