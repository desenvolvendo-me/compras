class AddRevenueAccountingsYearAndEntityIdIndex < ActiveRecord::Migration
  def change
    add_index :compras_revenue_accountings, [:code, :entity_id, :year], :unique => true, :name => :index_c_revenue_accountings_code_entity_id_year
  end
end
