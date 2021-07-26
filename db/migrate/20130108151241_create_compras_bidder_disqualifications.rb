class CreateComprasBidderDisqualifications < ActiveRecord::Migration
  def change
    create_table :compras_bidder_disqualifications do |t|
      t.references :bidder
      t.string :reason
      t.timestamps
    end

    add_index :compras_bidder_disqualifications, :bidder_id
    add_foreign_key :compras_bidder_disqualifications, :compras_bidders, :column => :bidder_id
  end
end
