class RenameCommunicationSourcesNameToDescription < ActiveRecord::Migration
  def change
    rename_column :communication_sources, :name, :description
  end
end
