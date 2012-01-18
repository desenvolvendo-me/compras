class ChangeColumnValueInFieldValuesToString < ActiveRecord::Migration
  def up
    change_column :field_values, :value, :string
  end

  def down
    change_column :field_values, :value, :integer
  end
end
