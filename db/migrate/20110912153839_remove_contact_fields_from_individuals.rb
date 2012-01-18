class RemoveContactFieldsFromIndividuals < ActiveRecord::Migration
  def up
    remove_column :individuals, :phone
    remove_column :individuals, :fax
    remove_column :individuals, :mobile
    remove_column :individuals, :email
  end

  def down
    add_column :individuals, :phone, :string, :limit => 14
    add_column :individuals, :fax, :string, :limit => 14
    add_column :individuals, :mobile, :string, :limit => 14
    add_column :individuals, :email, :string
  end
end