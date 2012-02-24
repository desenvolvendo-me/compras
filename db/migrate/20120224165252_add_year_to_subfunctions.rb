class AddYearToSubfunctions < ActiveRecord::Migration
  def change
    add_column :subfunctions, :year, :integer
  end
end
