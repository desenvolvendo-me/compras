class RemoveCodeFromAdministrationTypes < ActiveRecord::Migration
  def change
    remove_column :administration_types, :code
  end
end
