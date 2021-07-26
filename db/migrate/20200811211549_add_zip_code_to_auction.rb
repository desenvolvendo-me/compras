class AddZipCodeToAuction < ActiveRecord::Migration
  def change
    add_column :compras_auctions, :zip_code, :string
  end
end
