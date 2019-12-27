class CodeDescriptionToProjectActivity < ActiveRecord::Migration
  def change
    add_column :compras_project_activities,
               :code_description, :string
  end
end