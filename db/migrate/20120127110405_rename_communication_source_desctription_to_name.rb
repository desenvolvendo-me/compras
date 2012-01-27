class RenameCommunicationSourceDesctriptionToName < ActiveRecord::Migration
  def change
    rename_column :communication_sources, :description, :name
  end
end
