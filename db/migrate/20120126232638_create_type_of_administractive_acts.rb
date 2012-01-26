class CreateTypeOfAdministractiveActs < ActiveRecord::Migration
  def change
    create_table :type_of_administractive_acts do |t|
      t.string :description

      t.timestamps
    end
  end
end
