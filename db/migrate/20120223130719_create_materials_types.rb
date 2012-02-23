class CreateMaterialsTypes < ActiveRecord::Migration
  def change
    create_table :materials_types do |t|
      t.string :description

      t.timestamps
    end
  end
end
