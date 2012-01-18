class RenameTableContributorsToPeople < ActiveRecord::Migration
  def up
    rename_table :contributors, :people
  end

  def down
    rename_table :people, :contributors
  end
end
