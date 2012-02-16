class CreatePledgeCategories < ActiveRecord::Migration
  def change
    create_table :pledge_categories do |t|
      t.string :description
      t.string :status

      t.timestamps
    end
  end
end
