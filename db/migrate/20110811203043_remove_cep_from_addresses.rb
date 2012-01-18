class RemoveCepFromAddresses < ActiveRecord::Migration
  def up
    remove_column :addresses, :cep
  end

  def down
    add_column :addresses, :cep, :string
  end
end
