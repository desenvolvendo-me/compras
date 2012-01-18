class ChangeColumnCodeToString < ActiveRecord::Migration
  def up
    change_column :banks, :code, :string
  end

  def down
    change_column :banks, :code, :integer
  end
end