class RemoveNumberFromCondominium < ActiveRecord::Migration
  def up
    remove_column :condominiums, :number
  end

  def down
    add_column :condominiums, :number, :integer
  end
end
