class AddDistrictIdToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :district_id, :integer
  end
end
