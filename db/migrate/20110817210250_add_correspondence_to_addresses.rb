class AddCorrespondenceToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :correspondence, :boolean
  end
end
