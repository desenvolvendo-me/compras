class AddCepToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :cep, :string
  end
end
