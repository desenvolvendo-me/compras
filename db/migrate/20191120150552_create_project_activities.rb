class CreateProjectActivities < ActiveRecord::Migration
  def change
    create_table :compras_project_activities do |t|
      t.string :name
      t.date :year
      t.integer :destiny
      t.string :code
      t.string :code_sub_project_activity

      t.timestamps
    end
  end
end
