class RenameCompanySizesToUnicoCompanySizes < ActiveRecord::Migration
  def change
    rename_table :company_sizes, :unico_company_sizes
  end
end
