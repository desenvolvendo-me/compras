class RemoveNeighborhoodIdFromCondominiums < ActiveRecord::Migration
  def change
    remove_foreign_key :condominiums, :neighborhoods
    remove_column :condominiums, :neighborhood_id
  end
end
