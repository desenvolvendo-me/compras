class AddPersonIdAsFkToCompanies < ActiveRecord::Migration
  def change
    add_foreign_key :companies, :people
  end
end
