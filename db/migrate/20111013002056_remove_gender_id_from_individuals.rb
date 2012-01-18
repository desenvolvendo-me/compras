class RemoveGenderIdFromIndividuals < ActiveRecord::Migration
  def change
    remove_foreign_key :individuals, :name => :people_gender_id_fk
    remove_column :individuals, :gender_id
  end
end
