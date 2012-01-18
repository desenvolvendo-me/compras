class AddFaceOfTheBlockToSectionStreets < ActiveRecord::Migration
  def change
    add_column :section_streets, :face_of_the_block, :string
  end
end
