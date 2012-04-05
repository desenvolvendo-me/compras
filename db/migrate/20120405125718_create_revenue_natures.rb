class CreateRevenueNatures < ActiveRecord::Migration
  def change
    create_table :revenue_natures do |t|
      t.string :code
      t.string :description
      t.integer :revenue_category_id

      t.timestamps
    end

    add_index :revenue_natures, :revenue_category_id

    add_foreign_key :revenue_natures, :revenue_categories
  end
end
