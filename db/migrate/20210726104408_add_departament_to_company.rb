class AddDepartamentToCompany < ActiveRecord::Migration
  def change
    add_column :unico_companies, :departament, :string
  end
end
