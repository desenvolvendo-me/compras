class RemoveContactFieldsFromCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :phone
    remove_column :companies, :fax
    remove_column :companies, :mobile
    remove_column :companies, :email
  end

  def down
    add_column :companies, :phone, :string, :limit => 14
    add_column :companies, :fax, :string, :limit => 14
    add_column :companies, :mobile, :string, :limit => 14
    add_column :companies, :email, :string
  end
end
