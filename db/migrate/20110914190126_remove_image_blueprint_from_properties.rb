class RemoveImageBlueprintFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :image_blueprint
  end
end
