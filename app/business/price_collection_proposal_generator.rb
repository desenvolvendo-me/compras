class PriceCollectionProposalGenerator
  attr_accessor :price_collection, :providers, :proposals, :items, :proposal_storage, :proposal_item_storage

  def initialize(price_collection, proposal_storage = PriceCollectionProposal, proposal_item_storage = PriceCollectionProposalItem)
    self.price_collection = price_collection
    self.providers = price_collection.providers
    self.proposals = price_collection.price_collection_proposals
    self.items = price_collection.items
    self.proposal_storage = proposal_storage
    self.proposal_item_storage = proposal_item_storage
  end

  def generate!
    create_proposals_for_new_providers
    create_proposals_items
  end

  def create_proposals_for_new_providers
    providers.each do |provider|
      create_proposal(provider) unless have_proposal?(provider)
    end
  end

  def create_proposal(provider)
    proposal_storage.create!(:price_collection_id => price_collection.id,
                             :provider_id => provider.id)
  end

  def have_proposal?(provider)
    !proposal_storage.by_price_collection_and_provider(:price_collection_id => price_collection.id,
                                                       :provider_id => provider.id).empty?
  end

  def create_proposals_items
    items.each do |item|
      proposals.each do |proposal|
        create_proposal_item(proposal, item) unless have_proposal_item?(proposal, item)
      end
    end
  end

  def create_proposal_item(proposal, item)
    proposal_item_storage.create!(:price_collection_proposal_id => proposal.id,
                                  :price_collection_lot_item_id => item.id)
  end

  def have_proposal_item?(proposal, item)
    !proposal_item_storage.by_proposal_and_item(:proposal_id => proposal.id,
                                                :item_id => item.id).empty?
  end
end
