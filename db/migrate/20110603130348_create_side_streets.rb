class CreateSideStreets < ActiveRecord::Migration
  def change
    create_table :side_streets do |t|
      t.string :name
      t.string :acronym

      t.timestamps
    end
  end
end
