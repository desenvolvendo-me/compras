class AddKindToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :kind, :string
  end
end
