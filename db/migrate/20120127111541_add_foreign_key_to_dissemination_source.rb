class AddForeignKeyToDisseminationSource < ActiveRecord::Migration
  def change
    add_foreign_key :dissemination_sources, :communication_sources
  end
end
