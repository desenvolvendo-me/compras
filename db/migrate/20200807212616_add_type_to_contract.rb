class AddTypeToContract < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :type, :string
  end
end
