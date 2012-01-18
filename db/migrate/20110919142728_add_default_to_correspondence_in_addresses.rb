class AddDefaultToCorrespondenceInAddresses < ActiveRecord::Migration
  def up
    change_column :addresses, :correspondence, :boolean, :default => false, :null => false
  end

  def down
    change_column :addresses, :correspondence, :boolean
  end
end
