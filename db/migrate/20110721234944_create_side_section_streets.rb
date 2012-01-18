class CreateSideSectionStreets < ActiveRecord::Migration
  def change
    create_table :side_section_streets do |t|
      t.string :acronym
      t.string :name

      t.timestamps
    end
  end
end
