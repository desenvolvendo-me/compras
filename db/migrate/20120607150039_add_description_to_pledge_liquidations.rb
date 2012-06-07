class AddDescriptionToPledgeLiquidations < ActiveRecord::Migration
  def change
    add_column :pledge_liquidations, :description, :string
  end
end
