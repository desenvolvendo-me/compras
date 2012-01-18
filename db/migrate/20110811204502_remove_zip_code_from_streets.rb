class RemoveZipCodeFromStreets < ActiveRecord::Migration
  def up
    remove_column :streets, :zip_code
  end

  def down
    add_column :streets, :zip_code, :string
  end
end
