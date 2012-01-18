class AddDiscountTypeToSplittings < ActiveRecord::Migration
  def change
    add_column :splittings, :discount_type, :string
  end
end
