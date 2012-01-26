class CreateMaterialsClasses < ActiveRecord::Migration
  def change
    create_table :materials_classes do |t|
      t.references :materials_group
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :materials_classes, :materials_group_id
    add_foreign_key :materials_classes, :materials_groups
  end
end
