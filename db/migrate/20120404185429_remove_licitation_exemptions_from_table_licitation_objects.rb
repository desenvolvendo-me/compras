class RemoveLicitationExemptionsFromTableLicitationObjects < ActiveRecord::Migration
  def change
    remove_column :licitation_objects, :purchase_licitation_exemption
    remove_column :licitation_objects, :build_licitation_exemption
  end
end
