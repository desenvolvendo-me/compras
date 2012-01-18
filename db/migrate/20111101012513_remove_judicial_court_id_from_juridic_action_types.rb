class RemoveJudicialCourtIdFromJuridicActionTypes < ActiveRecord::Migration
  def up
    remove_index  :juridic_action_types, :judicial_court_id
    remove_foreign_key :juridic_action_types, :judicial_courts
    remove_column :juridic_action_types, :judicial_court_id
  end

  def down
    add_column :juridic_action_types, :judicial_court_id, :integer
    add_index  :juridic_action_types, :judicial_court_id
    add_foreign_key :juridic_action_types, :judicial_courts
  end
end
