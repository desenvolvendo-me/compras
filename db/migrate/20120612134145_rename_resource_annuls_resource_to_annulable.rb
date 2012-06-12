class RenameResourceAnnulsResourceToAnnulable < ActiveRecord::Migration
  def change
    change_table :resource_annuls do |t|
      t.rename :resource_id, :annullable_id
      t.rename :resource_type, :annullable_type
    end

    add_index :resource_annuls, [:annullable_id, :annullable_type]
  end
end
