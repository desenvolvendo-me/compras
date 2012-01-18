class RemoveStreetIdFromCondominium < ActiveRecord::Migration
  def change
    remove_column :condominiums, :street_id
  end
end
