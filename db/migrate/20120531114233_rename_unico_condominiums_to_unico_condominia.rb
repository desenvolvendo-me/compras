class RenameUnicoCondominiumsToUnicoCondominia < ActiveRecord::Migration
  def change
    rename_table :unico_condominiums, :unico_condominia
  end
end
