class RemoveObjectDescriptionFromLicitationProcess < ActiveRecord::Migration
  def change
    remove_column :licitation_processes, :object_description
  end
end
