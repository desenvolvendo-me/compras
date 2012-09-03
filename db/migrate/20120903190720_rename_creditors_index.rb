class RenameCreditorsIndex < ActiveRecord::Migration
  def change
    rename_index :compras_creditors, :cc_classifiable, :cc_creditable
  end
end
