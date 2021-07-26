class PriceCollectionClassificationGenerator
  attr_accessor :price_collection, :price_collection_classification_repository

  delegate :type_of_calculation, :price_collection_proposals, :price_collection_lots_with_items, :items, :to => :price_collection

  def initialize(price_collection, price_collection_classification_repository = PriceCollectionClassification)
    self.price_collection = price_collection
    self.price_collection_classification_repository = price_collection_classification_repository
  end

  def generate!
    price_collection.destroy_all_price_collection_classifications

    price_collection_proposals.not_anull.each do |proposal|
      send(type_of_calculation, proposal)
    end

    check_if_winner_has_zero!
  end

  protected

  def check_if_winner_has_zero!
    price_collection.all_price_collection_classifications.group_by(&:classifiable_id).each do |classifiable_id, classifications|
      classifications = classifications.sort_by(&:classification)

      if classifications.first.disqualified?
        classification = classifications.reject(&:disqualified?).first
        if classification
          classification.update_column(:classification, 1)
        end
      end
    end
  end

  def lowest_total_price_by_item(proposal)
    proposal.items.each do |proposal_item|
      price_collection_classification_repository.create!(
        :unit_value => proposal_item.unit_price,
        :total_value => proposal_item.unit_price * proposal_item.quantity,
        :classification => proposal.classification_by_item(proposal_item),
        :price_collection_proposal => proposal_item.price_collection_proposal,
        :classifiable => proposal_item.price_collection_item
      )
    end
  end

  def lowest_global_price(proposal)
    price_collection_classification_repository.create!(
      :total_value => proposal.total_price,
      :classification => proposal.global_classification,
      :price_collection_proposal => proposal,
      :classifiable => price_collection
    )
  end

  def lowest_price_by_lot(proposal)
    proposal.price_collection_lots.each do |lot|
      price_collection_classification_repository.create!(
        :total_value => proposal.item_total_value_by_lot(lot),
        :classification => proposal.classification_by_lot(lot),
        :price_collection_proposal => proposal,
        :classifiable => proposal.price_collection,
        :lot => lot
      )
    end
  end
end
