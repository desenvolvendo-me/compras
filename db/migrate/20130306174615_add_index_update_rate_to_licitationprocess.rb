class AddIndexUpdateRateToLicitationprocess < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :index_update_rate_id, :integer

    add_index  :compras_licitation_processes, :index_update_rate_id
    add_foreign_key :compras_licitation_processes, :compras_indexers, :column => :index_update_rate_id
  end
end
