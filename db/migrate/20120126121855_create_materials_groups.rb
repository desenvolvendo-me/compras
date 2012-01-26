class CreateMaterialsGroups < ActiveRecord::Migration
  def change
    create_table :materials_groups do |t|
      t.string :group
      t.string :name

      t.timestamps
    end
  end
end
