class RemoveYearFromProjectActivity < ActiveRecord::Migration
  def change
    remove_column :compras_project_activities,
               :year
  end
end
