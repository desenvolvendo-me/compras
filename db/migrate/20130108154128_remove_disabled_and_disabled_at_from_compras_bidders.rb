class RemoveDisabledAndDisabledAtFromComprasBidders < ActiveRecord::Migration
  def change
    Bidder.where(:disabled => true).find_each do |bidder|
      BidderDisqualification.create!(
        :bidder_id => bidder.id, :reason => 'Licitante inabilitado')
    end

    remove_column :compras_bidders, :disabled
    remove_column :compras_bidders, :disabled_at
  end
end
