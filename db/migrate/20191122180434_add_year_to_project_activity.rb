class AddYearToProjectActivity < ActiveRecord::Migration
  def change
    add_column :compras_project_activities,
               :year, :integer
  end
end