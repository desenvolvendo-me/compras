class AddCpfToPeople < ActiveRecord::Migration
  def change
    add_column :people, :cpf, :string
  end
end
