class AddIndexOnIndividualIdOnIdentities < ActiveRecord::Migration
  def change
    add_index :identities, :individual_id
  end
end
