class AddSourceToPledgeCategories < ActiveRecord::Migration
  def change
    add_column :pledge_categories, :source, :string
  end
end
