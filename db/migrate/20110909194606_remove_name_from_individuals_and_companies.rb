class RemoveNameFromIndividualsAndCompanies < ActiveRecord::Migration
  def up
    remove_column :individuals, :name
    remove_column :companies, :name
  end

  def down
    add_column :individuals, :name, :string
    add_column :companies, :name, :string
  end
end
