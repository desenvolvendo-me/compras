class RefactorTableAuction < ActiveRecord::Migration
  def up
    remove_column :compras_auctions, :licitation_number
    remove_column :compras_auctions, :year
    remove_column :compras_auctions, :judment_form
    remove_column :compras_auctions, :object
    remove_column :compras_auctions, :variation_type
    remove_column :compras_auctions, :minimum_interval
  end

  def down
    add_column :compras_auctions, :licitation_number, :string
    add_column :compras_auctions, :year, :integer
    add_column :compras_auctions, :judment_form, :string
    add_column :compras_auctions, :object, :text
    add_column :compras_auctions, :variation_type, :string
    add_column :compras_auctions, :minimum_interval, :string
  end
end
