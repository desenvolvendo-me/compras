class PriceCollectionClassificationGenerator
  attr_accessor :price_collection, :price_collection_classification_repository

  delegate :type_of_calculation, :price_collection_proposals, :price_collection_lots, :items, :to => :price_collection

  def initialize(price_collection, price_collection_classification_repository = PriceCollectionClassification)

    self.price_collection = price_collection
    self.price_collection_classification_repository = price_collection_classification_repository
  end

  def generate!
    send(type_of_calculation)
  end

  protected

  def lowest_total_price_by_item
    items.each do |item|
      item.proposal_items.each_with_index do |proposal_item, index|
        price_collection_classification_repository.create!(
          :unit_value => proposal_item.unit_price,
          :total_value => proposal_item.unit_price * item.quantity,
          :classification => index + 1,
          :creditor => proposal_item.creditor,
          :classifiable => item)
      end
    end
  end

  def lowest_global_price
    price_collection.proposals_with_total_value.each_with_index do |proposal_with_total_value, index|
      price_collection_classification_repository.create!(
        :total_value => proposal_with_total_value.total_value,
        :classification => index + 1,
        :creditor => proposal_with_total_value.creditor,
        :classifiable => price_collection)
    end
  end

  def lowest_price_by_lot
    price_collection_lots.each do |lot|
      lot.lots_with_total_value.each_with_index do |lot_with_total_value, index|
        price_collection_classification_repository.create!(
          :total_value => lot_with_total_value.total_value,
          :classification => index + 1,
          :creditor_id => lot_with_total_value.creditor_id,
          :classifiable => lot)
      end
    end
  end
end
