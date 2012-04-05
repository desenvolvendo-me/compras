class CreateRevenueCategories < ActiveRecord::Migration
  def change
    create_table :revenue_categories do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
