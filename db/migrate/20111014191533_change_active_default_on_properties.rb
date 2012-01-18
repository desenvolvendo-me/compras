class ChangeActiveDefaultOnProperties < ActiveRecord::Migration
  def up
    change_column_default :properties, :active, false
  end

  def down
    change_column_default :properties, :active, nil
  end
end
