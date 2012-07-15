class PriceCollectionClassificationGenerator
  attr_accessor :price_collection_proposal_item_storage, :price_collection_classification_storage
  attr_accessor :price_collection, :price_collection_proposal_storage, :classifications

  delegate :type_of_calculation, :price_collection_proposals, :price_collection_lots, :items, :to => :price_collection

  def initialize(price_collection,
                 price_collection_proposal_item_storage = PriceCollectionProposalItem,
                 price_collection_proposal_storage = PriceCollectionProposal,
                 price_collection_classification_storage = PriceCollectionClassification,
                 classifications = [])

    self.price_collection = price_collection
    self.price_collection_proposal_item_storage = price_collection_proposal_item_storage
    self.price_collection_proposal_storage = price_collection_proposal_storage
    self.price_collection_classification_storage = price_collection_classification_storage

    self.classifications = classifications
  end

  def generate!
    send(type_of_calculation)

    classifications
  end

  protected

  def lowest_total_price_by_item
    items.each do |item|
      proposal_items = price_collection_proposal_item_storage.by_item_order_by_unit_price(item.id)

      proposal_items.each_with_index do |proposal_item, index|
        classifications << price_collection_classification_storage.new(
                             :unit_value => proposal_item.unit_price,
                             :total_value => proposal_item.unit_price * item.quantity,
                             :classification => index + 1,
                             :creditor => proposal_item.creditor,
                             :classifiable => item)
      end
    end
  end

  def lowest_global_price
    proposals_with_total_value = price_collection_proposal_storage.by_price_collection_id_sum_items(price_collection.id)

    proposals_with_total_value.each_with_index do |proposal_with_total_value, index|
      classifications << price_collection_classification_storage.new(
                           :total_value => proposal_with_total_value.total_value,
                           :classification => index + 1,
                           :creditor => proposal_with_total_value.creditor,
                           :classifiable => price_collection)
    end
  end

  def lowest_price_by_lot
    price_collection_lots.each do |lot|
      lots_with_total_value = price_collection_proposal_item_storage.by_lot_item_order_by_unit_price(lot.id)

      lots_with_total_value.each_with_index do |lot_with_total_value, index|
        classifications << price_collection_classification_storage.new(
                             :total_value => lot_with_total_value.total_value,
                             :classification => index + 1,
                             :creditor_id => lot_with_total_value.creditor_id,
                             :classifiable => lot)

      end
    end
  end
end
