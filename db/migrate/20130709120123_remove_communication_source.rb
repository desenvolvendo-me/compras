class RemoveCommunicationSource < ActiveRecord::Migration
  def change
    drop_table :compras_communication_sources
  end
end
