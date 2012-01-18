class RenameTablePeopleToIndividuals < ActiveRecord::Migration
  def up
    rename_table :people, :individuals
  end

  def down
    rename_table :individuals, :people
  end
end
