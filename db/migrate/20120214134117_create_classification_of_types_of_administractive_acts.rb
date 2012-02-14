class CreateClassificationOfTypesOfAdministractiveActs < ActiveRecord::Migration
  def change
    create_table :classification_of_types_of_administractive_acts do |t|
      t.string :description

      t.timestamps
    end
  end
end
