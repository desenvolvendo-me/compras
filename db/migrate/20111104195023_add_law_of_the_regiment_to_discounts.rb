class AddLawOfTheRegimentToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :law_of_the_regiment, :string
  end
end
