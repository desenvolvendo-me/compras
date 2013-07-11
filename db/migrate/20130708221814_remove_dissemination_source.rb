class RemoveDisseminationSource < ActiveRecord::Migration
  def change
    drop_table :compras_dissemination_sources
  end
end
