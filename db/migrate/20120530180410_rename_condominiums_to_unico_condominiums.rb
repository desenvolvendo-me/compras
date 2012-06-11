class RenameCondominiumsToUnicoCondominiums < ActiveRecord::Migration
  def change
    rename_table :condominiums, :unico_condominiums
  end
end
