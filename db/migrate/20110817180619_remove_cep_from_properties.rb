class RemoveCepFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :cep
  end

  def down
    add_column :properties, :cep, :string
  end
end
