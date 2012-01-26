class AddMissingIndexToDisseminationSource < ActiveRecord::Migration
  def change
    add_index :dissemination_sources, :communication_source_id
  end
end
