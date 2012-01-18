class CreateJuridicActionTypes < ActiveRecord::Migration
  def change
    create_table :juridic_action_types do |t|
      t.string :name
      t.string :classification
      t.references :judicial_court

      t.timestamps
    end
    add_index :juridic_action_types, :judicial_court_id
    add_foreign_key :juridic_action_types, :judicial_courts
  end
end
