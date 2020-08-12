class AddResponsibleToPeople < ActiveRecord::Migration
  def change
    add_column :unico_companies, :responsible_name, :string
  end
end
