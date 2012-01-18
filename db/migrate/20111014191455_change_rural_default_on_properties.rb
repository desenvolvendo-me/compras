class ChangeRuralDefaultOnProperties < ActiveRecord::Migration
  def up
    change_column_default :properties, :rural, false
  end

  def down
    change_column_default :properties, :rural, nil
  end
end
