class AddJudicialCodeToJuridicActionTypes < ActiveRecord::Migration
  def change
    add_column :juridic_action_types, :judicial_code, :string
  end
end
