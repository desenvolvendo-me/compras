class RemoveCodeFromDistricts < ActiveRecord::Migration
  def change
    remove_column :districts, :code
  end
end
