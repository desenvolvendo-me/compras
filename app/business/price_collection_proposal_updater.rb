class PriceCollectionProposalUpdater
  def initialize(price_collection, proposal_item_repository=PriceCollectionProposalItem)
    @price_collection = price_collection
    @proposal_item_repository = proposal_item_repository
  end

  def update!
    create_proposal_items
  end

  private
  def proposals
    @proposals ||= @price_collection.price_collection_proposals
  end

  def items
    @items ||= @price_collection.items
  end

  def create_proposal_items
    proposals.each do |proposal|
      items.each do |item|
        create_proposal_item(proposal, item)
      end
    end
  end

  def create_proposal_item(proposal, item)
    return if have_proposal_item?(proposal, item)
    @proposal_item_repository.create!(:price_collection_proposal_id => proposal.id,
                                  :price_collection_lot_item_id => item.id)
  end

  def have_proposal_item?(proposal, item)
    !@proposal_item_repository.by_proposal_and_item(:proposal_id => proposal.id,
                                                :item_id => item.id).empty?
  end
end
