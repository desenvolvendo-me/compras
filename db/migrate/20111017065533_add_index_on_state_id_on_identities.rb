class AddIndexOnStateIdOnIdentities < ActiveRecord::Migration
  def change
    add_index :identities, :state_id
  end
end
