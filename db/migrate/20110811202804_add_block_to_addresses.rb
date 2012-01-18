class AddBlockToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :block, :string
  end
end
