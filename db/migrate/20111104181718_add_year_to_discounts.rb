class AddYearToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :year, :integer
  end
end
