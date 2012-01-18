class ChangeColumnCrcInAccountantsToString < ActiveRecord::Migration
  def up
    change_column :accountants, :crc, :string
  end

  def down
    change_column :accountants, :crc, :integer
  end
end
