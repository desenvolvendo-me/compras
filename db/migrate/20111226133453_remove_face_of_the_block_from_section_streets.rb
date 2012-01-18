class RemoveFaceOfTheBlockFromSectionStreets < ActiveRecord::Migration
  def change
    remove_column :section_streets, :face_of_the_block
  end
end
