class AddMaxAndMinValueToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :max_value, :decimal, :precision => 10, :scale => 2
    add_column :agreements, :min_value, :decimal, :precision => 10, :scale => 2
  end
end
