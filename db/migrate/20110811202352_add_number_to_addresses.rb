class AddNumberToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :number, :integer
  end
end
